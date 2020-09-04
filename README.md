# Weather
iOS application written in Swift, RxSwfit & RxCocoa, DI pattern and MVVM-C.

# Application Features

- [x] weather list screen
<br> : This screen is displaying list of the selected city's weather (with UITableView)
- [ ] weather detail screen
<br> : This screen will show selected city's detail weatehr information
- [x] city list screen with
<br> : This screen is displaying list of the city (with UITableView & UISearchController)

# Architecture & Pattern
This project includes MVVM-C ( MVVM Coordinator ),  DI ( Dependency Injection )

- MVVM
ViewModel is an abstract view. A viewModel and each element of the view are bind to each other and update the state accordingly.
A view doesn't know Model and through data binding there no dependency between view and viewModel too.

- Coordinator pattern
Coordinator handles navigation flow it makes more scalable and lighter the ViewController's responsibility.
It is introduced in 2015 by [Soroush Khanlou](https://khanlou.com/)

