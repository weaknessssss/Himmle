# Swift UI Development Guidelines

## Table of Contents
1. [Introduction](#introduction)
2. [Declarative Programming Principles](#declarative-programming-principles)
3. [View Hierarchy Best Practices](#view-hierarchy-best-practices)
4. [State Management](#state-management)
5. [Database Integration](#database-integration)
6. [Performance Considerations](#performance-considerations)
7. [Testing and Debugging](#testing-and-debugging)
8. [Appendix: Common Patterns](#appendix-common-patterns)

## Introduction

This document outlines best practices for developing applications using SwiftUI, Apple's modern declarative framework for building user interfaces across all Apple platforms. Following these guidelines will help ensure that your applications are maintainable, performant, and adhere to Apple's design principles.

## Declarative Programming Principles

SwiftUI embraces declarative programming, representing a fundamental shift from the imperative approach used in UIKit and AppKit. In declarative programming, you describe *what* the UI should look like for any given state, rather than *how* to update it when changes occur.

### Core Principles

**State as the single source of truth:**
Your UI should be a function of your application's state. When the state changes, SwiftUI automatically updates the UI to reflect those changes.

```swift
struct ContentView: View {
    @State private var isToggled = false
    
    var body: some View {
        VStack {
            Text(isToggled ? "On" : "Off")
            
            Toggle("Toggle State", isState: $isToggled)
        }
        .padding()
    }
}
```

**Avoid imperative modifications:**
Instead of manually manipulating views, define how your UI should appear based on different states:

```swift
// Recommended (Declarative)
var body: some View {
    if isLoading {
        ProgressView()
    } else {
        ListView(items: loadedItems)
    }
}

// Not recommended (Imperative thinking)
// Don't try to "show" or "hide" views imperatively
```

**Composition over inheritance:**
Build complex UIs by composing small, reusable components rather than creating complex view hierarchies through inheritance.

## View Hierarchy Best Practices

A proper view hierarchy is crucial for SwiftUI performance and maintainability. The hierarchy must reflect the logical structure of your UI components.

### Hierarchy Guidelines

**1. Start with container views at the top level:**
Begin with primary containers such as `NavigationView`, `TabView`, or `WindowGroup` that establish the fundamental structure.

```swift
@main
struct MyApp: App {
    var body: some Scene {
        WindowGroup {
            NavigationView {
                ContentView()
            }
        }
    }
}
```

**2. Break down complex views into subviews:**
Maintain a clear hierarchy by extracting logical components into separate view structures:

```swift
struct ProfileView: View {
    var user: User
    
    var body: some View {
        VStack(alignment: .leading) {
            UserHeaderView(user: user)
            UserStatsView(stats: user.stats)
            UserContentListView(content: user.content)
        }
    }
}
```

**3. Respect layout container hierarchies:**
Use the appropriate containers in the correct order:

```swift
// Correct hierarchy
VStack {
    Text("Header")
    
    HStack {
        Image(systemName: "star")
        Text("Details")
    }
    
    ForEach(items) { item in
        ItemRow(item: item)
    }
}
```

**4. Limit view hierarchy depth:**
Overly deep view hierarchies can impact performance. Aim for balanced, logical groupings.

## State Management

Proper state management is essential in SwiftUI's declarative paradigm.

### Property Wrappers

Use the appropriate property wrapper for each type of state:

**@State**: For local, private state that belongs to a specific view  
**@Binding**: For state that is passed from a parent view to be modified  
**@ObservedObject**: For external objects that conform to ObservableObject  
**@EnvironmentObject**: For objects that need to be accessible throughout a view hierarchy  
**@StateObject**: For owned ObservableObject instances that persist for the lifetime of the view  

```swift
struct ItemDetailView: View {
    // Owned state
    @State private var isExpanded = false
    
    // Received from parent
    @Binding var quantity: Int
    
    // External model
    @ObservedObject var itemRepository: ItemRepository
    
    // Environment-wide services
    @EnvironmentObject var userSession: UserSession
    
    var body: some View {
        // View implementation
    }
}
```

## Database Integration

**Database integration is critical for storing and retrieving information in SwiftUI applications.** A proper database implementation ensures data persistence, performance, and reliability.

### Database Requirements

**1. Always use databases for persistent storage:**
It is imperative to use a database solution for storing user information, application state, and content data rather than relying on in-memory structures alone.

```swift
// Application structure with database integration
struct MyApp: App {
    let persistenceController = PersistenceController.shared
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
```

**2. Choose the appropriate database technology:**
- **Core Data**: For complex object graphs and relationships
- **SQLite**: For structured data with SQL query requirements
- **CloudKit**: For synchronized data across devices
- **Realm**: As a third-party alternative for reactive databases

**3. Implement proper data access layers:**
Separate your database logic from your UI components:

```swift
// Data repository pattern
class TaskRepository: ObservableObject {
    private let context: NSManagedObjectContext
    
    @Published var tasks: [Task] = []
    
    init(context: NSManagedObjectContext) {
        self.context = context
        fetchTasks()
    }
    
    func fetchTasks() {
        let request: NSFetchRequest<Task> = Task.fetchRequest()
        
        do {
            tasks = try context.fetch(request)
        } catch {
            print("Error fetching tasks: \(error)")
        }
    }
    
    func saveTask(title: String, dueDate: Date) {
        let task = Task(context: context)
        task.id = UUID()
        task.title = title
        task.dueDate = dueDate
        task.isCompleted = false
        
        saveContext()
        fetchTasks()
    }
    
    private func saveContext() {
        do {
            try context.save()
        } catch {
            print("Error saving context: \(error)")
        }
    }
}
```

**4. Connect database to SwiftUI views:**
Use ObservableObject conformance to reactively update the UI when database content changes:

```swift
struct TaskListView: View {
    @StateObject private var repository = TaskRepository(context: PersistenceController.shared.container.viewContext)
    @State private var newTaskTitle = ""
    
    var body: some View {
        List {
            ForEach(repository.tasks) { task in
                TaskRow(task: task)
            }
        }
        .toolbar {
            Button("Add Task") {
                if !newTaskTitle.isEmpty {
                    repository.saveTask(title: newTaskTitle, dueDate: Date())
                    newTaskTitle = ""
                }
            }
        }
    }
}
```

## Performance Considerations

Performance optimization is essential in SwiftUI applications, especially with complex view hierarchies and database operations.

### Performance Best Practices

**1. Use lazy loading for lists and collections:**
Employ `LazyVStack` and `LazyHStack` for views that may contain many items:

```swift
ScrollView {
    LazyVStack {
        ForEach(items) { item in
            ItemRow(item: item)
        }
    }
}
```

**2. Implement pagination for large datasets:**
When working with databases, retrieve data in manageable chunks:

```swift
func fetchItems(page: Int, pageSize: Int) {
    let request: NSFetchRequest<Item> = Item.fetchRequest()
    request.fetchLimit = pageSize
    request.fetchOffset = page * pageSize
    
    // Execute fetch and handle results
}
```

**3. Cache expensive computations:**
Use memoization to avoid redundant calculations:

```swift
// Using a computed property with caching
var filteredItems: [Item] {
    if cachedFilter == currentFilter, let cached = cachedItems {
        return cached
    }
    
    let result = items.filter { /* filtering logic */ }
    cachedFilter = currentFilter
    cachedItems = result
    return result
}
```

## Testing and Debugging

### Testing SwiftUI Views

**1. Test view behavior:**
Focus on testing how views respond to state changes:

```swift
func testToggleCompletionUpdatesUI() {
    let task = TaskModel(id: UUID(), title: "Test Task", isCompleted: false)
    let view = TaskView(task: task, onToggle: { task.isCompleted.toggle() })
    
    // Verify initial state
    XCTAssertFalse(view.isCompleted)
    
    // Simulate toggle action
    view.onToggle()
    
    // Verify updated state
    XCTAssertTrue(view.isCompleted)
}
```

**2. Test database operations:**
Create isolated test environments for database operations:

```swift
func testSaveAndRetrieveTask() {
    let context = PersistenceController.preview.container.viewContext
    let repository = TaskRepository(context: context)
    
    repository.saveTask(title: "Test Task", dueDate: Date())
    
    XCTAssertEqual(repository.tasks.count, 1)
    XCTAssertEqual(repository.tasks.first?.title, "Test Task")
}
```

## Appendix: Common Patterns

### MVVM with SwiftUI

The Model-View-ViewModel (MVVM) pattern works particularly well with SwiftUI's declarative approach:

```swift
// Model
struct TaskItem: Identifiable {
    let id: UUID
    let title: String
    var isCompleted: Bool
}

// ViewModel
class TaskListViewModel: ObservableObject {
    @Published var tasks: [TaskItem] = []
    
    private let databaseService: DatabaseService
    
    init(databaseService: DatabaseService) {
        self.databaseService = databaseService
        loadTasks()
    }
    
    func loadTasks() {
        databaseService.fetchTasks { [weak self] result in
            switch result {
            case .success(let tasks):
                DispatchQueue.main.async {
                    self?.tasks = tasks
                }
            case .failure(let error):
                print("Failed to load tasks: \(error)")
            }
        }
    }
    
    func toggleTask(_ task: TaskItem) {
        guard let index = tasks.firstIndex(where: { $0.id == task.id }) else { return }
        tasks[index].isCompleted.toggle()
        
        // Update database
        databaseService.updateTask(tasks[index])
    }
}

// View
struct TaskListView: View {
    @StateObject private var viewModel = TaskListViewModel(databaseService: DatabaseServiceImpl())
    
    var body: some View {
        List {
            ForEach(viewModel.tasks) { task in
                HStack {
                    Text(task.title)
                    Spacer()
                    Image(systemName: task.isCompleted ? "checkmark.circle.fill" : "circle")
                }
                .onTapGesture {
                    viewModel.toggleTask(task)
                }
            }
        }
    }
}
```

This architecture maintains a clear separation of concerns while leveraging SwiftUI's declarative nature and reactive updates.

---

By following these guidelines, you will build SwiftUI applications that are maintainable, performant, and aligned with Apple's recommended practices. Remember that proper database integration is essential for storing application data, and a well-structured view hierarchy is fundamental to the declarative programming paradigm that makes SwiftUI so powerful.
