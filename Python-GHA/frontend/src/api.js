const API_URL = "http://localhost:8000"

export async function getTodos() {
  const res = await fetch(`${API_URL}/todos`)
  return res.json()
}

export async function addTodo(task) {
  await fetch(`${API_URL}/todos`, {
    method: "POST",
    headers: { "Content-Type": "application/json" },
    body: JSON.stringify({ task })
  })
}
