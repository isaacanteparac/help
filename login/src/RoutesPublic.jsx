import {Route, Routes} from "react-router-dom";
import Login from "./Login.jsx";
import SingUp from "./SignUp.jsx";

export default function RoutesPublic() {
    return (
        <Routes>
            <Route path='/' element={<Login/>}/>
            <Route path='/signup' element={<SingUp/>}/>
        </Routes>
    )
}