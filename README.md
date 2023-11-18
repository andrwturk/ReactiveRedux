# Lightweight Redux framework powered by Combine

## Introduction
ReactiveRedux is a lightweight, reactive Redux framework for Swift. It simplifies state management in your Swift applications. Whether you are using SwiftUI or UIKit, ReactiveRedux offers built-in support for action creators, allowing for a clean, easy-to-understand data flow.

## Usage Example
Here's an example that uses ReactiveRedux in a SwiftUI application to manage a simple chat view. This example shows how to obtain message hostory from Redux storage and send message to the dispatcher. More detailed example can be found in Example folder.

```swift

struct ChatView: View {
    
    @State private var messages: [String]
    let storage: StateStorage<ChatState, ChatAction>
    @State private var cancellables = Set<AnyCancellable>()
    @State private var newMessage: String = ""
    
    var body: some View {
        VStack {
            ScrollView {
                ForEach(messages, id: \.self) { message in
                    Text(message)
                }
            }
            HStack {
                TextField("", text: $newMessage)
                Button("Send Message") {
                    storage
                        .reduxDispatcher
                        .dispatch(action: .sendMessage(newMessage))
                }
            }
        }.onAppear {
            storage
                .observeState()
                .receive(on: DispatchQueue.main)
                .sink(receiveCompletion: { _ in
                }, receiveValue: { state in
                    messages = state.messages
                })
                .store(in: &cancellables)
        }
    }
}
```

## Example App: Building a Chat Application
In this repository, you will find a complete example application that demonstrates how to build a real-time chat application using the ReactiveRedux framework. The example aims to showcase the core features and usage patterns of ReactiveRedux in a more complex use-case.

## Contributing
Your contributions are welcome! Feel free to open issues for feature requests or bug reports, and submit pull requests for new features or fixes. For major changes, it's always good to open an issue first to discuss what you would like to change.
