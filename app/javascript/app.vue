<template>
  <div id="app">
    <section class="todoapp">
      <header class="header">
        <h1>todos</h1>
        <input
          class="new-todo"
          autofocus
          autocomplete="off"
          placeholder="What needs to be done?"
          v-model="newTodo"
          @keyup.enter="addTodo"
        />
      </header>
      <section class="main" v-show="todos.length" v-cloak>
        <input
          id="toggle-all"
          class="toggle-all"
          type="checkbox"
          v-model="allDone"
        />
        <label for="toggle-all"></label>
        <ul class="todo-list">
          <li
            v-for="todo in filteredTodos"
            class="todo"
            :key="todo.id"
            :class="{ completed: todo.completed, editing: todo == editedTodo }"
          >
            <div class="view">
              <input class="toggle" type="checkbox" v-model="todo.completed" />
              <label @dblclick="editTodo(todo)">{{ todo.title }}</label>
              <button class="destroy" @click="removeTodo(todo)"></button>
            </div>
            <input
              class="edit"
              type="text"
              v-model="todo.title"
              v-todo-focus="todo == editedTodo"
              @blur="doneEdit(todo)"
              @keyup.enter="doneEdit(todo)"
              @keyup.esc="cancelEdit(todo)"
            />
          </li>
        </ul>
      </section>
      <footer class="footer" v-show="todos.length" v-cloak>
        <span class="todo-count">
          <strong>{{ remaining }}</strong> {{ remaining | pluralize }} left
        </span>
        <ul class="filters">
          <li>
            <a href="#/all"
               v-on:click="visibility = 'all'"
               :class="{ selected: visibility == 'all' }">
              All
            </a>
          </li>
          <li>
            <a href="#/active"
               v-on:click="visibility = 'active'"
               :class="{ selected: visibility == 'active' }">
              Active
            </a>
          </li>
          <li>
            <a
              href="#/completed"
              v-on:click="visibility = 'completed'"
              :class="{ selected: visibility == 'completed' }">
              Completed
            </a>
          </li>
        </ul>
        <button
          class="clear-completed"
          @click="removeCompleted"
          v-show="todos.length > remaining"
        >
          Clear completed
        </button>
      </footer>
    </section>
  </div>
</template>

<script>
var axios = require('axios')

var todoInterface = {
  fetch: function() {
    return axios.get('/api/v1/todo')
      .then(function (response) {
        var retrieved_todos = response['data']['results'];

        todoInterface.uid = retrieved_todos.length;
        return retrieved_todos;
      })
      .catch(function (error) {
        console.log(error);
      });
  },
  save: function(todos) {
    return axios.put('/api/v1/todo', todos)
      .then(function (response) {
        var retrieved_todos = response['data']['results'];

        todoInterface.uid = retrieved_todos.length;
        return retrieved_todos;
      })
      .catch(function (error) {
        console.log(error);
      });
  }
};

// visibility filters
var filters = {
  all: function(todos) {
    return todos;
  },
  active: function(todos) {
    return todos.filter(function(todo) {
      return !todo.completed;
    });
  },
  completed: function(todos) {
    return todos.filter(function(todo) {
      return todo.completed;
    });
  }
};

export default {
  data: function () {
    return {
        todos: [],
        newTodo: "",
        editedTodo: null,
        visibility: "all"
    }
  },

  mounted: function () {
    console.log("initializing todo list");
    var top = this;
    todoInterface.fetch().then(res => {
      res.forEach(function(retrieved_item, index) {
        top.todos.push({
          remote_id: retrieved_item.id,
          title: retrieved_item.title,
          completed: retrieved_item.completed
        });
      });
    });
  },

  // watch todos change for persistence
  watch: {
    todos: {
      handler: function(todos) {
        todoInterface.save({ line_items: todos }).then(res => {
          var new_item = res.map(x => x.id).filter(function(obj) { return todos.map(x => x.remote_id).indexOf(obj) == -1; })[0];
          var empty_line_item = todos.filter(function(obj) { return  obj.remote_id === undefined })[0];

          if(new_item && empty_line_item) {
            empty_line_item.remote_id = new_item
          }
        });
      },
      deep: true
    }
  },

  // computed properties
  // http://vuejs.org/guide/computed.html
  computed: {
    filteredTodos: function() {
      return filters[this.visibility](this.todos);
    },
    remaining: function() {
      return filters.active(this.todos).length;
    },
    allDone: {
      get: function() {
        return this.remaining === 0;
      },
      set: function(value) {
        this.todos.forEach(function(todo) {
          todo.completed = value;
        });
      }
    }
  },

  filters: {
    pluralize: function(n) {
      return n === 1 ? "item" : "items";
    }
  },

  // methods that implement data logic.
  // note there's no DOM manipulation here at all.
  methods: {
    addTodo: function() {
      var value = this.newTodo && this.newTodo.trim();
      if (!value) {
        return;
      }
      this.todos.push({
        title: value,
        completed: false
      });
      this.newTodo = "";
    },

    removeTodo: function(todo) {
      this.todos.splice(this.todos.indexOf(todo), 1);
    },

    editTodo: function(todo) {
      this.beforeEditCache = todo.title;
      this.editedTodo = todo;
    },

    doneEdit: function(todo) {
      if (!this.editedTodo) {
        return;
      }
      this.editedTodo = null;
      todo.title = todo.title.trim();
      if (!todo.title) {
        this.removeTodo(todo);
      }
    },

    cancelEdit: function(todo) {
      this.editedTodo = null;
      todo.title = this.beforeEditCache;
    },

    removeCompleted: function() {
      this.todos = filters.active(this.todos);
    }
  },

  // a custom directive to wait for the DOM to be updated
  // before focusing on the input field.
  // http://vuejs.org/guide/custom-directive.html
  directives: {
    "todo-focus": function(el, binding) {
      if (binding.value) {
        el.focus();
      }
    }
  }
}
</script>

<style scoped>
p {
  font-size: 2em;
  text-align: center;
}

[v-cloak] {
  display: none;
}
</style>
