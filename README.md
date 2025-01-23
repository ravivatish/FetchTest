# FetchTest App README

## Requirements
- **iOS Version**: iOS 16 and above
- **Platform**: Targeting iOS only
---

## Architecture
This app uses **MVVM (Model-View-ViewModel)** to keep things clean and organized. I’ve also added a **HomeUseCase Domain Layer** to make sure the ViewModel doesn’t get bogged down with data-fetching logic.

### Highlights:
1. **Keeping Things Separate**:
   - The ViewModel handles updating the UI and nothing else.
   - The Domain Layer (HomeUseCase) takes care of all the behind-the-scenes logic, like deciding which data to show.

2. **Caching Game Plan**:
   - Right now, it’s using **disk caching** to store data locally.
   - Added **volatile caching** on top of disk caching to improve performance. Volatile caching stores frequently accessed data in memory, significantly reducing retrieval times for subsequent requests.
   - Built with an **array-based LRU (Least Recently Used)** caching system, which works but isn’t the fastest with its **O(n)** operations.
   - What’s next? Replace the array with a **doubly linked list + hash table** combo to get it running at **O(1)**.

3. **UI Focus**:
   - I didn’t spend much time on the UI

---

## Testing Strategy
Testing was a big part of this project. Here’s what’s covered:
1. **HomeViewModel Tests**:
   - Made sure the `recipes` publisher updates correctly when the data changes.
2. **StorageService Tests**:
   - Checked that the cache clears itself properly when it hits the size limit.
   - Verified the LRU logic works as expected.
3. **UseCase Tests**:
   - Tested the HomeUseCase to ensure it’s picking the right data source based on the storage response.
---

## Project Highlights

### Focus Areas:
- **Domain Layer**: The backbone of the app’s architecture, ensuring things stay modular and organized.
- **Caching System**: Built a working LRU caching system for local data storage 
- **ViewModel Logic**: Kept the ViewModel simple and focused only on updating the UI.

### Time Spent:
- Total: 5 to 6 hours
 
### Trade-offs and Decisions:
- **Caching**: Chose an array-based LRU system because it’s quick to implement, even though it’s not the most efficient.
- **UI**: Kept the design functional but didn’t focus on visuals.
- **Domain Layer**: Added complexity to the project but made the code more maintainable.

### Weakest Part of the Project:
- **UI**: The design could use more polish and user-friendly touches.
- **LRU Implementation**: It works but isn’t optimized for performance yet.

### Additional Info:
- The project’s goal was to focus on solid architecture and functionality over fancy design.
- Time constraints meant skipping further optimizations and more advanced UI elements.
---

