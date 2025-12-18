import { useEffect, useState } from "react"
import { getTodos, addTodo } from "./api"

function App() {
  const [todos, setTodos] = useState([])
  const [task, setTask] = useState("")

  useEffect(() => {
    loadTodos()
  }, [])

  async function loadTodos() {
    const data = await getTodos()
    setTodos(data)
  }

  async function handleAdd() {
    if (!task) return
    await addTodo(task)
    setTask("")
    loadTodos()
  }

  return (
    <div style={{ padding: "20px" }}>
      <h1>Todo App</h1>
      <input
        value={task}
        onChange={(e) => setTask(e.target.value)}
        placeholder="New task"
      />
      <button onClick={handleAdd}>Add</button>

      <ul>
        {todos.map((t, i) => (
          <li key={i}>{t.task}</li>
        ))}
      </ul>
    </div>
  )
}

export default App
