import {Navigate, Route, Routes} from "react-router-dom";
import Dashboard from "./Dashboard.jsx";

export default function RoutesPrivate(){
    const auth = localStorage.getItem('auth')
    if (!auth){
        return <Navigate to='/'/>
    }

    return(
        <Routes>
            <Route path='/' element={<Dashboard/>}/>
        </Routes>
    )
}