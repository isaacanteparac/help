import { BrowserRouter, Route, Routes } from "react-router-dom"
import Practica from "./public/practica"
import Navigation from "./public/Navigation"
import Practica2 from "./public/Practica2"


function App() {

  return (
    <BrowserRouter>
    <Navigation />
      <Routes>
        <Route path="/" element={<Practica />} />
        <Route path="/practica" element={<Practica2 />} />
        <Route path="*" element={<div>404 Not Found</div>} />
      </Routes>
    </BrowserRouter>


  )
}

export default App
