//
//  WorkoutViewModelTests.swift
//  lab1Tests
//
//  Created by A-Z pack group on 16.12.2025.
//
import XCTest
@testable import lab1

final class WorkoutViewModelTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        UserDefaults.standard.removeObject(forKey: "lastExerciseSyncDate")
    }
    
    override func tearDown() {
        UserDefaults.standard.removeObject(forKey: "lastExerciseSyncDate")
        super.tearDown()
    }
    
    
    private func makeSUT() async -> (WorkoutViewModel, MockWorkoutRepository) {
        await MainActor.run {
            let repo = MockWorkoutRepository()
            let vm = WorkoutViewModel(repository: repo)
            return (vm, repo)
        }
    }
    
    func test_addExercise_usesWorkoutNameIfNotEmpty() async {
        let (vm, _) = await makeSUT()
        
        await MainActor.run {
            vm.workoutName = "Bench"
            vm.addExercise()
            
            XCTAssertEqual(vm.exercises.count, 1)
            XCTAssertEqual(vm.exercises[0].name, "Bench")
            XCTAssertEqual(vm.exercises[0].sets, 3)
            XCTAssertEqual(vm.exercises[0].reps, 10)
        }
    }
    
    func test_addExercise_whenWorkoutNameEmpty_usesDefaultExerciseName() async {
        let (vm, _) = await makeSUT()
        
        await MainActor.run {
            vm.workoutName = ""
            vm.addExercise()
            
            XCTAssertEqual(vm.exercises.count, 1)
            XCTAssertEqual(vm.exercises[0].name, "Exercise")
        }
    }
    
    func test_saveWorkout_whenNameEmpty_showsAlertAndDoesNotSave() async {
        let (vm, repo) = await makeSUT()
        
        await MainActor.run {
            vm.workoutName = "   "
            vm.exercises = [ExerciseItem(name: "Squat", sets: 3, reps: 10)]
            
            vm.saveWorkout()
            
            XCTAssertTrue(vm.showingAlert)
            XCTAssertEqual(vm.lastSaveMessage, "Please enter a workout name before saving.")
            XCTAssertTrue(repo.savedWorkoutsSnapshots.isEmpty)
            XCTAssertTrue(vm.workouts.isEmpty)
        }
    }
    
    func test_saveWorkout_whenNoExercises_showsAlertAndDoesNotSave() async {
        let (vm, repo) = await makeSUT()
        
        await MainActor.run {
            vm.workoutName = "Leg day"
            vm.exercises = []
            
            vm.saveWorkout()
            
            XCTAssertTrue(vm.showingAlert)
            XCTAssertEqual(vm.lastSaveMessage, "Add at least one exercise before saving.")
            XCTAssertTrue(repo.savedWorkoutsSnapshots.isEmpty)
            XCTAssertTrue(vm.workouts.isEmpty)
        }
    }
    
    func test_saveWorkout_success_appendsThenResetsBuilderState() async {
        let (vm, repo) = await makeSUT()
        
        await MainActor.run {
            vm.workoutName = "Push"
            vm.exercises = [ExerciseItem(name: "Bench", sets: 3, reps: 10)]
            vm.intensity = 0.8
            
            vm.saveWorkout()
        }
        
        // даємо Task всередині saveWorkout() виконатись
        await Task.yield()
        
        await MainActor.run {
            XCTAssertTrue(vm.showingAlert)
            XCTAssertTrue(vm.lastSaveMessage.contains("Saved"))
            XCTAssertEqual(repo.savedWorkoutsSnapshots.count, 1)
            
            XCTAssertEqual(vm.workoutName, "")
            XCTAssertTrue(vm.exercises.isEmpty)
            XCTAssertEqual(vm.intensity, 0.5, accuracy: 0.0001)
        }
    }
    
    func test_saveWorkout_failure_keepsBuilderAndShowsError() async {
        let (vm, repo) = await makeSUT()
        repo.saveWorkoutsResult = .failure(TestError.boom)
        
        await MainActor.run {
            vm.workoutName = "Pull"
            vm.exercises = [ExerciseItem(name: "Row", sets: 3, reps: 10)]
            
            vm.saveWorkout()
        }
        
        await Task.yield()
        
        await MainActor.run {
            XCTAssertTrue(vm.showingAlert)
            XCTAssertTrue(vm.lastSaveMessage.contains("Save failed:"))
            XCTAssertEqual(vm.workoutName, "Pull")
            XCTAssertEqual(vm.exercises.count, 1)
        }
    }
    
    func test_deleteWorkout_removesFromMemoryAndCallsRepository() async {
        let (vm, repo) = await makeSUT()
        let w1 = Workout(id: UUID(), name: "A",
                         exercises: [ExerciseItem(name: "X", sets: 1, reps: 1)],
                         date: Date(), intensity: 0.5)
        let w2 = Workout(id: UUID(), name: "B",
                         exercises: [ExerciseItem(name: "Y", sets: 1, reps: 1)],
                         date: Date(), intensity: 0.5)
        
        await MainActor.run {
            vm.workouts = [w1, w2]
            vm.deleteWorkout(at: IndexSet(integer: 0))
        }
        
        await Task.yield()
        
        await MainActor.run {
            XCTAssertEqual(vm.workouts.count, 1)
            XCTAssertEqual(vm.workouts[0].id, w2.id)
            XCTAssertEqual(repo.deletedWorkoutIDs, [w1.id])
        }
    }
    
    func test_loadInitialData_loadsWorkoutsAndCachedRemoteAndLastSync() async {
        let (vm, repo) = await makeSUT()
        
        let w = Workout(id: UUID(), name: "Saved",
                        exercises: [ExerciseItem(name: "Squat", sets: 3, reps: 5)],
                        date: Date(), intensity: 0.7)
        repo.loadWorkoutsResult = .success([w])
        repo.loadCachedRemoteExercisesResult = .success([])
        
        let ts = Date().timeIntervalSince1970
        UserDefaults.standard.set(ts, forKey: "lastExerciseSyncDate")
        
        await MainActor.run {
            vm.loadInitialData()
        }
        
        await Task.yield()
        
        await MainActor.run {
            XCTAssertEqual(vm.workouts.count, 1)
            XCTAssertEqual(vm.workouts[0].name, "Saved")
            XCTAssertNotNil(vm.lastSyncText)
        }
    }
    
    func test_fetchExercises_success_updatesRemoteAndCachesAndSyncDate() async {
        let (vm, repo) = await makeSUT()
        
        let json = """
        {
          "success": true,
          "data": [{
            "exerciseId": "1",
            "name": "Push Up",
            "imageUrl": null,
            "bodyParts": ["chest"],
            "equipments": ["body weight"],
            "exerciseType": "strength",
            "targetMuscles": ["pectorals"],
            "secondaryMuscles": [],
            "keywords": []
          }]
        }
        """.data(using: .utf8)!
        
        let decoded = try! JSONDecoder().decode(ExerciseSearchResponse.self, from: json).data
        repo.fetchRemoteExercisesResult = .success(decoded)
        
        await MainActor.run {
            vm.fetchExercises(query: "push")
        }
        
        await Task.yield()
        
        await MainActor.run {
            XCTAssertFalse(vm.isLoadingRemote)
            XCTAssertNil(vm.remoteErrorMessage)
            XCTAssertFalse(vm.isOfflineFallback)
            XCTAssertEqual(vm.remoteExercises.count, 1)
            XCTAssertEqual(repo.cachedRemoteSavedSnapshots.count, 1)
            XCTAssertNotNil(vm.lastSyncText)
            XCTAssertNotNil(UserDefaults.standard.object(forKey: "lastExerciseSyncDate"))
        }
    }
    
    func test_fetchExercises_failure_loadsCacheAndSetsOfflineFlags() async {
        let (vm, repo) = await makeSUT()
        
        repo.fetchRemoteExercisesResult = .failure(TestError.boom)
        
        let json = """
        {
          "success": true,
          "data": [{
            "exerciseId": "2",
            "name": "Squat",
            "imageUrl": null,
            "bodyParts": ["legs"],
            "equipments": ["body weight"],
            "exerciseType": "strength",
            "targetMuscles": ["quads"],
            "secondaryMuscles": [],
            "keywords": []
          }]
        }
        """.data(using: .utf8)!
        
        let cached = try! JSONDecoder().decode(ExerciseSearchResponse.self, from: json).data
        repo.loadCachedRemoteExercisesResult = .success(cached)
        
        await MainActor.run {
            vm.fetchExercises(query: "legs")
        }
        
        await Task.yield()
        
        await MainActor.run {
            XCTAssertFalse(vm.isLoadingRemote)
            XCTAssertTrue(vm.isOfflineFallback)
            XCTAssertNotNil(vm.remoteErrorMessage)
            XCTAssertEqual(vm.remoteExercises.count, 1)
        }
    }
}
