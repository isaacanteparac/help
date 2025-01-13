import {useState} from "react";
import {BrowserRouter as Router, Route, Routes} from 'react-router-dom';
import RoutesPublic from "./RoutesPublic.jsx";
import RoutesPrivate from "./RoutesPrivate.jsx";



export default function App() {

    return (
        <main>
            <Router>
                <Routes>
                   <Route path='/*' element={<RoutesPublic/>}/>
                   <Route path='/dashboard/*' element={<RoutesPrivate/>}/>
                </Routes>
            </Router>
        </main>

    )
}