## Promises

Angular事件系统（我们会在揭秘Angular章节讨论它）给Angular应用提供了很多能力。它给我们的最强大功能之一是promise的自动执行。

### 什么是Promise？

Promise是一种用异步方式执行值（或者非值）的方法。Promise是对象，代表了返回值，或者是一个函数最终可能抛出的异常。在与远程对象打交道时，promise会非常有用，可以把它们看作远程对象的一个代理。

习惯上，JavaScript使用闭包或者回调来响应非同步的有意义的数据，比如页面加载之后的XHR请求。我们可以跟数据进行交互，就好像它已经返回了一样，而不需要依赖于回调函数的触发。

回调的使用有很长时间了，但开发人员用起来很痛苦。回调带来了不一致性和没有保证的调用，当依赖于其他回调的时候，它们篡改代码的流程，通常会让调试变得非常难。在这种方式的每个步骤，我们都需要*显式*处理错误。

不同于在执行异步方法时触发一个函数，然后期待一个回调能运行起来，promise提供了一个不同的抽象：它们返回promise对象。

例如：在传统的回调代码中，我们可能会有一个方法来从一个用户给他的一个朋友发送数据。

```JavaScript
 1 // 示例回调代码
 2 User.get(fromId, {
 3     success: function(err, user) {
 4         if (err) return {error: err};
 5         user.friends.find(toId, function(err, friend) {
 6             if (err) return {error: err};
 7             user.sendMessage(friend, message, callback);
 8         });
 9     },
10     failure: function(err) {
11         return {error: err}
12     }
13 });
```

这个回调金字塔已经失控了，我们还没有包括任何健壮的错误处理代码。此外，我们还需要在被调用的回调内部知道参数的顺序。

刚才代码的基于promise的版本看上去更接近于：

```JavaScript
 1 User.get(fromId)
 2     .then(function(user) {
 3         return user.friends.find(toId);
 4     }, function(err) {
 5     // 没找到用户
 6 })
 7 .then(function(friend) {
 8     return user.sendMessage(friend, message);
 9 }, function(err) {
10     // 用户的朋友返回了异常
11 })
12 .then(function(success) {
13     // user was sent the message
14 }, function(err) {
15     // 发生错误了
16 });
```

代码不仅仅是可读性变高了，也更容易理解了。我们可以保证回调会执行为一个值，而不用处理回调接口。

注意在第一个例子中，我们需要用跟处理正常状况不同的方式去处理异常。需要确定在什么时候使用回调来处理错误，在一个传统的API响应函数签名（惯例的方法签名通常是(err, data)）中检查错误是否已定义。我们所有的API方法都需要实现同样的结构。

在第二个例子里，我们用同样的方式处理成功和错误。合成对象将会以常见的方式接收到错误。promise API是明确地执行或者拒绝promise的，所以不必担心我们的方法实现了不同的方法签名。

### Why Promises?

使用promise的附带收获之一是逃脱了*回调地狱*。promise的真正点是让异步函数看上去像同步的。基于同步函数，我们可以按照预期来捕获返回值和异常值。

可以在程序中的任何时候捕捉错误，并且绕过依赖于程序异常的后续代码。我们不需要思考这个同步代码带来的好处，就已经达到上述目的了 —— 它就在代码的本质中。

因此，使用promise的目的是：获得功能组合和异常冒泡能力的同时，保持代码异步运行的能力。

Promise是*一等*对象，自带了一些保证：

- 只有一个resolve或者reject会被调用到
    - resolve被调用的时候，带有一个履行值
    - reject可以被带一个拒绝原因调用
- 如果promise被执行或者拒绝了，依赖于它们的处理函数仍然会被调用
- 处理函数总是会被异步调用


此外，可以把promise串起来，并且允许代码以通常运行的方式来处理。从一个promise冒出的异常会贯穿整个promise链。

promise总是被异步执行的，可以放心使用，无需担心它们会阻塞应用的其他部分。

### Angular中的Promise

Angular的事件循环给予了Angular特有的能力，能在$rootScope.$evalAsync阶段中执行promise（关于运行循环的更多细节，参见揭秘Angular章节）。promise会坐等$digest运行循环结束。

这件事让我们能毫无压力地把promise的结果转换到视图上。它也能让我们不加思考地把XHR调用的结果直接赋值到$scope对象的属性上。

我们来建一个例子，从GitHub上返回一个对AngularJS的开放pull请求。

[来玩玩吧][69]

```HTML
1 <h1>Open Pull Requests for Angular JS</h1>
2
3 <ul ng-controller="DashboardController">
4   <li ng-repeat="pr in pullRequests">
5     {{ pr.title }}
6   </li>
7 </ul>
```

如果有个服务返回了一个promise（在服务章节会深入探讨），可以在.then()方法中与这个promise交互，它允许我们修改作用域上的任意变量，放置到视图上，并且期望Angular会为我们执行它：


```JavaScript
 1 angular.module('myApp', [])
 2 .controller('DashboardController', [
 3     '$scope', 'GithubService',
 4         function($scope, UserService) {
 5             // GithubService的getPullRequests()方法
 6             // 返回了一个promise
 7             User.getPullRequests(123)
 8             .then(function(data) {
 9                 $scope.pullRequests = data.data;
10         });
11 }]);
```

当对getPullRequests的异步调用返回时，在.then()方法中就可以用$scope.pullRequests这个值了，然后它会更新$scope.pullRequests数组。

#### 如何创建一个Promise

想要在Angular中创建promise，可以使用内置的$q服务。$q服务在它的deferred API中提供了一些方法。

首先，需要把$q服务注入到想要使用它的对象中。

```JavaScript
1 angular.module('myApp', [])
2    .factory('GithubService', ['$q', function($q) {
3    // 现在就可以访问到$q库了
4 }]);
```

要创建一个deferred对象，可以调用defer()方法：

```JavaScript
1 var deferred = $q.defer();
```

deferred对象暴露了三个方法，以及一个可以用于处理promise的promise属性。

- resolve(value) resolve函数用这个值来执行deferred promise。

```JavaScript
1 deferred.resolve({name: "Ari", username: "@auser"});
```

- reject(reason) 这个方法用一个原因来*拒绝*deferred promise。它等同于使用一个“拒绝”来执行一个promise。

```JavaScript
1 deferred.reject("Can't update user");
2 // 等同于
3 deferred.resolve($q.reject("Can't update user"));
```

- notify(value) 这个方法用promise的执行状态来进行响应。

例如，如果我们要从promise返回一个状态，可以使用notify()函数来传送它。

假设我们想要从一个promise创建多个长时间运行的请求。可以调用nodify函数发回一个过程通知：

```JavaScript
 1 .factory('GithubService', function($q, $http) {
 2     // 从仓库获取事件
 3     var getEventsFromRepo = function() {
 4         // 任务
 5     }
 6     var service = {
 7         makeMultipleRequests: function(repos) {
 8             var d = $q.defer(),
 9                 percentComplete = 0,
10                 output = [];
11             for (var i = 0; i < repos.length; i++) {
12                 output.push(getEventsFromRepo(repos[i]));
13                 percentComplete = (i+1)/repos.length * 100;
14                 d.notify(percentComplete);
15             }
16
17             d.resolve(output);
18
19             return d.promise;
20         }
21     }
22     return service;
23 });
```

有了GithubService对象上的这个makeMultipleRequests()函数，每次一个仓库被获取和处理的时候，都会收到一个过程通知。

可以在我们对promise的使用中用到这个通知，在用promise的时候加第三个函数调用。例如：

```JavaScript
 1 .controller('HomeController',
 2     function($scope, GithubService) {
 3         GithubService.makeMultipleRequests([
 4             'auser/beehive', 'angular/angular.js'
 5         ])
 6         .then(function(result) {
 7             // 处理结果
 8         }, function(err) {
 9             // 发生错误了
10         }, function(percentComplete) {
11             $scope.progress = percentComplete;
12         });
13 });
```

可以在deferred对象上以属性的方式访问promise：

```JavaScript
1 deferred.promise
```

上述是如何创建一个函数用于响应promise的一个完整例子，看上去可能类似于下面这些GithubService上的方法。

```JavaScript
 1 angular.module('myApp', [])
 2     .factory('GithubService', [
 3         '$q', '$http',
 4         function($q, $http) {
 5             var getPullRequests = function() {
 6                 var deferred = $q.defer();
 7                 // 从Github获取打开的angularjs pull请求列表
 8                 $http.get('https://api.github.com/repos/angular/angular.js/pulls')
 9                 .success(function(data) {
10                     deferred.resolve(data);
11                 })
12                 .error(function(reason) {
13                     deferred.reject(reason);
14                 })
15                 return deferred.promise;
16             }
17
18             return { // 返回工厂对象
19                 getPullRequests: getPullRequests
20             };
21 }]);
```

现在我们就可以用promise API来跟getPullRequests()来交互。

[查看完整示例][70]

在上面这个service的实例中，可以用两种不同方式跟promise交互：

- then(successFn, errFn, notifyFn)

无论promise成功还是失败了，当结果可用之后，then都会立刻异步调用successFn或者errFn。这个方法始终用一个参数来调用回调函数：结果，或者是拒绝的理由。

在promise被执行或者拒绝*之前*，notifyFn回调可能会被调用0到多次，以提供过程状态的提示。

then()方法总是返回一个新的promise，可以通过successFn或者errFn这样的返回值被执行或者拒绝。它也能通过notifyFn提供通知。

- catch(errFn) 这个方法就只是个帮助函数，能让我们用.catch(function(reason){})取代err回调：

```JavaScript
1 $http.get('/repos/angular/angular.js/pulls')
2     .catch(function(reason) {
3         deferred.reject(reason);
4 });
```

- finally(callback) finally方法允许我们观察promise的fulfillment或者rejection，而无需修改结果的值。当我们需要释放一个资源，或者是运行一些清理工作，不管promise是成功还是失败的时候，这个方法会很有用。


我们不能直接调用这个方法，因为finally是IE中JavaScript的一个保留字。纠结到最后，只好这样调用它了：

```JavaScript
1 promise['finally'](function() {});
```

Angular的$q deferred对象是可以串成链的，这样即使是then，返回的也是一个promise。这个promise一被执行，then返回的promise就已经是resolved或者rejected的了。

> 这些promise也就是Angular能支持$http拦截器的原因。

$q服务类似于原始的Kris Kowal的Q库：

1. $q是跟Angular的$rootScope模型集成的，所以在Angular中，执行和拒绝都很快。
2. $q promise是跟Angular模板引擎集成的，这意味着在视图中找到的任何promise都会在视图中被执行或者拒绝。
3. $q是很小的，所以没有包含Q库的完整功能。

### 链式请求

then方法在初始promise被执行之后，返回一个新的派生promise。这个返回给了我们一种特有的能力，把另一个then接在初始的then方法结果之后。

```JavaScript
 1 // 一个响应promise的服务
 2 GithubService.then(function(data) {
 3     var events = [];
 4     for (var i = 0; i < data.length; i++) {
 5         events.push(data[i].events);
 6     }
 7     return events;
 8 }).then(function(events) {
 9     $scope.events = events;
10 });
```

在本例中，我们可以创建一个执行链，它允许我们中断基于更多功能的应用流程，可以籍此导向不同的结果。这个中断能让我们在执行链的任意时刻暂停或者推迟promise的执行。

> 这个中断也是$http服务实现请求和响应拦截器的方式。

$q库自带了几个不同的有用方法：

#### all(promises)

如果我们有多个promise，想要把它们合并成一个，可以使用$q.all(promises)方法来把它们合并成一个promise。这个方法带有单个参数：

- promises（数组或者promise对象） 一个promise数组或者promise散列

all()方法返回单个promise，会执行一个数组或者一个散列的值。每个值会响应promise散列中的相同序号或者键。如果任意一个promise被拒绝了，结果的promise也会被拒绝。

#### defer()

defer()方法创建了一个deferred对象，它没有参数，返回deferred对象的一个实例。

#### reject(reason)

这个方法创建了一个promise，被以某一原因拒绝执行了。它是特意设计用于让我们能在一个promise链中转发拒绝的，类似JavaScript中的*throw*。在同样意义上，我们能在JavaScript中捕获一个异常，也能够转发这个拒绝，我们需要把这个错误重新抛出。可以通过$q.reject(reason)来做到这点。

这个方法带有单个参数：

- reason （常量，字符串，异常，对象） 拒绝的原因

reject()方法返回一个已经被用某个原因拒绝的promise。

#### when(value)

when()函数把一个可能是值或者能接着"then"的promise包装成一个$q promise。这让我们能处理一个可能是也可能不是promise的对象。

when()函数带单个参数：

- value 这个值，或者是promise

when()函数返回了一个promise，我们可以像其他的promise一样使用。
 

[69]:   http://jsbin.com/UfotanA/3/edit   "http://jsbin.com/UfotanA/3/edit"
[70]:   http://jsbin.com/UfotanA/3/edit   "http://jsbin.com/UfotanA/3/edit"