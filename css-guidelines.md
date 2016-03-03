title: css 规范指南
date: 2016-03-02 15:14:57
tag: 
- css   
categories:    
- 规范   
- 指南
---


## 一、前言

CSS不是一门优美的语言，尽管她容易上手，但在任何合理的规模下都会产生问题。很遗憾，我们并不能改变CSS的工作方式，但是可以改进编写和构建 CSS 的方法。

当进行大规模、长周期项目时，避免不了会和其他开发者协同工作，那么我们就需要以统一的方式来协作以便完成以下目标：

- 保持样式表的可维护性
- 保持代码的透明、稳健以及可读
- 保持样式表可扩展

### 1、规范样式风格的重要性

一个开发团队需要一份同意的CSS样式规范指南,因为：

- 项目开发、维护周期长
- 许多开发者参与
- 开发者有不同的编码方式、编码风格
- 新员工加入

一份良好的CSS样式规范可以做到：

- 设定代码质量的标准
- 保持代码的一致性
- 在整个代码库中给开发者以熟悉感，提到可维护性
- 提高代码开发效率

## 二、语法及格式（Syntax and Formatting）

整洁、统一的代码给人的感觉就是清爽。这能使人快速的投入工作的环境，促进其他团队成员去维持他们发现的整洁代码标准。丑陋的、蛋疼的代码则会造成不必要的损失。经常能听到周围骂声一片~

### 1、多文件（Multiple Files）

随着近年来急速发展的预处理器（如SASS、LESS）的发展，开发者通常将 CSS 分割成若干文件。

甚至，不适用预处理器，将不关联的代码快分割到独立的文件中也不失为一个好方法，在构建这一步中会重新拼凑起来。

### 2、80个字符宽度（80 Characters Wide）

限制CSS文件宽度为80个字符，原因如下：

- 能并排打开多个文件；
- 在线（如 Github）或终端中查看 CSS；
- 注释看起来更舒服。

```css
	/**
	 * I am a long-form comment. I describe, in detail, the CSS that follows. I am
	 * such a long comment that I easily break the 80 character limit, so I am
	 * broken across several lines.
	 */
```

### 3、标题

一般在每个主要部分前都要加一个标题，如：

```css
	/*------------------------------------*\
	    #记一笔
	\*------------------------------------*/
	
	.selector {}
```
标题加上一个 # 前缀让我们搜索的时候更容易命中，单纯搜索标题可能会有很多结果。在标题和代码（另一段注释、Sass 或 CSS）之间留一个空行。

如果每一小节代码在不同的文件中，标题应该出现在文件的最上面。如果一个文件中含有多个小节，则每个标题上面都应该有5个空行。这样当在大文件中快速下拉时能迅速分辨出不同的小节。

```css
	/*------------------------------------*\
	    #首页
	\*------------------------------------*/
	
	.selector {}
	
	
	
	
	
	/*------------------------------------*\
	    #记一笔
	\*------------------------------------*/
	
	/**
	 * 注释XXXX
	 */
	
	.another-selector {}
```

### 4、规则的结构（Anatomy of a Ruleset）

讨论之前，先熟悉下相关术语。

```css

	[selector] {
	    [property]: [value];
	    [<--declaration--->]
	}

```
例如：

```css

	.foo, .foo--bar,
	.baz {
	    display: block;
	    background-color: green;
	    color: red;
	}

```
我们遵循以下规范：

- 相关的选择器在同一行，不相关的选择器再另一行
- 花括号（{）之前有个空格
- 属性和值在同一行
- 冒号（:）之后有个空格
- 每条声明独立一行
- 花括号（{）与最后一个选择器在同一行
- 第一条声明在花括号（{）的下一行
- 花括号（}）独立一行
- 每条声明有`4`个空格的缩进
- 最后一条声明后面也有分号

比如下面是不正确的写法：

```css
	.foo, .foo--bar, .baz
	{
	    display:block;
	    background-color:green;
	    color:red }
```

这里的问题有：

- tab 缩进而不是空格缩进 
- 无关的选择器在同一行 
- 花括号（{）独立一行 
- 花括号（}）没有独立一行 
- 最后一个分号（;）缺失 
- 冒号（:）后面没有空格

### 5、多行CSS

除了一些特殊情况外，CSS都应该写成多行。这样做有多种好处：

- 代码合并时冲突的概率降低，因为每一条功能独立一行
- 方便文件差异比较，因为每一行只有一个变化
- 方便代码查看及修改

```css
	.icon {
	    display: inline-block;
	    width:  16px;
	    height: 16px;
	    background-image: url(/img/sprite.svg);
	}
	
	.icon--home     { background-position:   0     0  ; }
	.icon--person   { background-position: -16px   0  ; }
	.icon--files    { background-position:   0   -16px; }
	.icon--settings { background-position: -16px -16px; }
```

这种规则比单行写法更好，因为：

- 依然服从“一个改变一行”的原则
- 这几行代码有足够的相似度，因为阅读它们不像阅读其他代码那样仔细，更容易看到它们的选择器，这是我们更感兴趣的。

### 6、缩进（Indenting）

就像突出独立声明一样，将关联的规则通过缩进来展现其相关性，例如：

```css
	.foo {}

       .foo__bar {}

          .foo__baz {}
```

这样做，开发者一看就能知道 .foo__baz {} 在 .foo__bar {} 里，而 .foo__bar {} 又在 .foo {} 里。

### 7、对齐（Alignment）

将声明内一些共有的、关联的字符串对齐，比如：

```css
	.foo {
	    -webkit-border-radius: 3px;
	       -moz-border-radius: 3px;
	            border-radius: 3px;
	}
	
	.bar {
	    position: absolute;
	    top:    0;
	    right:  0;
	    bottom: 0;
	    left:   0;
	    margin-right: -10px;
	    margin-left:  -10px;
	    padding-right: 10px;
	    padding-left:  10px;
	}
```

使用能支持多光标编辑的编辑器(如：Sublime)会更轻松，开发者们可以一次修改若干相同而对齐的代码行。

### 8、HTML

将HTML的数据值用引号括起来，尽管不用引号也是有效的。

```css
  <div class="box">
```

当`class`属性里有多个值得时候，用1个空格隔开。

```css
   <div class="foo bar">
```

在`HTML`中使用有意义的空行也是可能的。你可以用2个空行表示主题间的隔断，例如：

```css
	<header class="page-head">
	    ...
	</header>
	
	
	<main class="page-content">
	    ...
	</main>
	
	
	<footer class="page-foot">
	    ...
	</footer>
```

用`1`个空行将独立却稍有关联的片段隔开，例如：

```css
	<ul class="primary-nav">

	    <li class="primary-nav__item">
	        <a href="/" class="primary-nav__link">Home</a>
	    </li>
	
	    <li class="primary-nav__item  primary-nav__trigger">
	        <a href="/about" class="primary-nav__link">About</a>
	
	        <ul class="primary-nav__sub-nav">
	            <li><a href="/about/products">Products</a></li>
	            <li><a href="/about/company">Company</a></li>
	        </ul>
	
	    </li>
	
	    <li class="primary-nav__item">
	        <a href="/contact" class="primary-nav__link">Contact</a>
	    </li>
	
	</ul>

```

这方便让开发者一眼就能看出 DOM 结构中的不同部分，同时也能让某些编辑器（如 Vim,Sublime）去处理空行分界的代码区域。

## 三、注释

注释的重要性就不需要多说了~ 是个开发人员基本都知道没注释的痛苦。但是由于`CSS`是一种不会留下太多痕迹的声明式语言，所以一般人好少写注释，但是，作为一个专业的前端....

所以，CSS 需要更多的注释。因为你可能不知道：

- 是否一段CSS代码与其他代码有关联
- 改变某段代码是否块影响其他模块
- 是否有其他的CSS使用到
- 样式继承
- 样式忽略

注释的规则是：你应该在任何有含义不明显的代码处写注释。意思是说，没必要告诉别人 `color: red;` 是用来变红的，但如果你用 `overflow: hidden; `来清除浮动（和闭合浮动相对），这时候添加注释是有必要的。

### 1、High-level

我们用一块80字符宽的多行注释来为整个小节或组件写注释。比如`CSS Wizardry`的页头样式注释：

```css
	/**
	 * The site’s main page-head can have two different states:
	 *
	 * 1) Regular page-head with no backgrounds or extra treatments; it just
	 *    contains the logo and nav.
	 * 2) A masthead that has a fluid-height (becoming fixed after a certain point)
	 *    which has a large background image, and some supporting text.
	 *
	 * The regular page-head is incredibly simple, but the masthead version has some
	 * slightly intermingled dependency with the wrapper that lives inside it.
	 */
```

很多时候我们想对一条规则中的多条声明进行注释。我们用一种颠倒的脚注。下面是一段更复杂的关于生面说到的网站头的注释。如`normalize.css`的注释：

```css
	/**
	 * 1. Set default font family to sans-serif.
	 * 2. Prevent iOS and IE text size adjust after device orientation change,
	 *    without disabling user zoom.
	 */
	
	html {
	  font-family: sans-serif; /* 1 */
	  -ms-text-size-adjust: 100%; /* 2 */
	  -webkit-text-size-adjust: 100%; /* 2 */
	}


```

这类注释允许我们将所有的文档写到一起，并且指向各自标注的地方。

需要注意的是生产环境中应该没有注释，所以发布前需要将所有的CSS进行压缩处理。

## 四、命名规则(Naming Conventions)

CSS中的命名规则非常有用，让你的代码更加严谨，更加显而易见，更加信息化。好的命名规则能告诉你和你的团队：

- 某个类做了什么类型的事
- 某个类能用在什么地方
- 什么样的类会有关联

1、连字符分割（Hyphen Delimited）

类名中所有的字符串都是用连字符（-）连接的，如：

```css
	.page-head {}

	.sub-content {}

```
驼峰命名方法一般不建议使用在类名中。

2、BEM 命名

先科普一下,`BEM`的意思是块（block）、元素（element）、修饰符（modifier）.是由[Yandex](https://www.yandex.ru/)团队提出的一种前端命名方法论。这种巧妙的命名方法让你的CSS类对其他开发者来说更加透明而且更有意义。BEM命名约定更加严格，而且包含更多的信息，它们用于一个团队开发一个耗时的大项目。

命名约定的模式如下：

```css
	.block{}
	.block__element{}
	.block--modifier{}
```

- .block 代表了更高级别的抽象或组件
- .block__element 代表.block的后代，用于形成一个完整的.block的整体。
- .block--modifier 代表.block的不同状态或不同版本。

之所以使用两个连字符和下划线而不是一个，是为了让你自己的块可以用单个连字符来界定，如：

```css
	.site-search{} /* 块 */
	.site-search__field{} /* 元素 */
	.site-search--full{} /* 修饰符 */
```

BEM的关键是光凭名字就可以告诉其他开发者某个标记是用来干什么的。通过浏览HTML代码中的class属性，你就能够明白模块之间是如何关联的：有一些仅仅是组件，有一些则是这些组件的子孙或者是元素,还有一些是组件的其他形态或者是修饰符。我们用一个类比/模型来思考一下下面的这些元素是怎么关联的：

```css
	.person{}
	.person__hand{}
	.person--female{}
	.person--female__hand{}
	.person__hand--left{}
```

顶级块是‘person’，它拥有一些元素，如‘hand’。一个人也会有其他形态，比如女性，这种形态进而也会拥有它自己的元素。又如：

```css
	<form class="site-search  site-search--full">
	  <input type="text" class="site-search__field">
	  <input type="Submit" value ="Search" class="site-search__button">
	</form>
```

我们能清晰地看到有个叫`.site-search`的块，他内部是一个叫`.site-search__field`的元素。并且`.site-search`还有另外一种形态叫`.site-search--full`。

尽管BEM写法看上去多少有点奇怪，但是无论什么项目，它对前端开发者都是一个巨有价值的工具。