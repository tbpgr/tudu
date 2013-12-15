# Tudu

Tudu is single person's minimum unit of task manager

## Purpose
* Manage single person's task.
* You shuold use this gem by minimun unit task. For example, make spec of Hoge#some_method, implements Hoge#some_method and so on.
* If you create some framework for user or your team, you can presentation minimum unit task-flow.
* If you have apprentice, you can presentation task-flow for them.

## Installation

Add this line to your application's Gemfile:

    gem 'tudu'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install tudu

## Structure
~~~
.
┗ tudu
    ┠ todos :todos(0-n task)
    ┠ doings :doing tasks(0-1 task)
    ┠ dones :done tasks(0-n task)
    ┗ Tudufile :in current version, we not use this
~~~

## Usage
### init
* generate todos,doings,dones emptyfile
* generate Tudufile template

~~~
$ tudu init
$ tree
.
┗ tudu
    ┠ todos
    ┠ doings
    ┠ dones
    ┗ Tudufile
~~~

### add task to todos file.
* single add

~~~
$ tudu add hoge
$ tudu todos
hoge
~~~

* multi add

~~~
$ tudu add hoge foo bar
$ tudu todos
hoge
foo
bar
~~~

### remove task to todos file.
* single remove

~~~
$ tudu add hoge hige
$ tudu remove hoge
$ tudu todos
hige
~~~

* multi remove

~~~
$ tudu add hoge foo bar hige
$ tudu remove hoge foo bar
$ tudu todos
hige
~~~

### choose task name. from todo to doing
* choose task_name

~~~
$ tudu add hoge
$ tudu choose hoge
$ tudu todos
$ tudu doings
hoge
~~~

### choose no args. from first todo to doing
* choose

~~~
$ tudu add hoge hige
$ tudu choose
$ tudu todos
hige
$ tudu doings
hoge
~~~

### done. from doing to done and from first todos to doing
* done

~~~
$ tudu add one two three
$ tudu choose one
$ tudu done
$ tudu todos
three
$ tudu doings
two
$ tudu done
one
~~~

### done. from doing to done and from first todos to doing. after, if there is no todos and doings, show celebration message.
* done

~~~
$ tudu add one two
$ tudu choose one
$ tudu done
$ tudu done
All Tasks Finish!!
$ tudu todos
$ tudu doings
$ tudu done
one
two
~~~

### tasks show all tasks from [todos, doings, dones].
* tudu tasks

~~~
$ tudu add one two three
$ tudu choose one
$ tudu done
$ tudu tasks
three
two
one
~~~

### tasks show all tasks from [todos, doings, dones] with categorized option.
* tudu tasks -c

~~~
$ tudu add one two three
$ tudu choose one
$ tudu done
$tudu tasks -c
========TODOS========
three

========DOINGS========
two

========DONES========
one
~~~

### show specific tasks from [todos, doings, dones].
* tudu tasks search_word

~~~
$ tudu add test tester testest
$ tudu search teste
tester
testest
~~~

### todos show all todos tasks.
* tudu todos

~~~
$ tudu add hoge hige
$ tudu choose hoge
$ tudu todos
hige
~~~

### todos 'search word' show specific todos tasks.
same as 'tasks search_word'

### doings show all doings tasks.
You can use doings command's alias 'now'

* tudu doings(or now)

~~~
$ tudu add hoge
$ tudu choose hoge
$ tudu doings
hoge
~~~

### doings 'search word' show specific doings tasks.
same as 'tasks search_word' case

### dones show all dones tasks.
* tudu dones

~~~
$ tudu add hoge hige
$ tudu choose hoge
$ tudu done
$ tudu doings
hige
$ tudu dones
hoge
~~~

### dones 'search word' show specific dones tasks.
same as 'tasks search_word' case

### Notes
if you want to do other operation, edit [todos, doings, dones] directly.

it's only plain text, so you can edit freely.

## History
* version 0.0.3 : add categorized option to tasks.
* version 0.0.2 : after execute 'done', if there is no todos and doings, display celebration message.
* version 0.0.2 : if 'choose' no args. choose first tudu.
* version 0.0.1 : first release.

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
