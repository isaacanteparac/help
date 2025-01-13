import {useState} from "react";
import {Link, useNavigate} from "react-router-dom";

export default function Login() {
    const [user, userSet] = useState('')
    const [password, passwordSet] = useState('')
    const [error, errorSet] = useState('')
    const navigate = useNavigate()


    function validation(e) {
        e.preventDefault()
        const dataUserStorage =  JSON.parse(localStorage.getItem('new_user'))
        const {user:userData, password: passwordData} = dataUserStorage
        if (user === userData && password === passwordData){
            localStorage.setItem('auth', true)
            navigate('/dashboard')
        }else{
            errorSet('error auth')
            setTimeout(()=>            errorSet(''),2000
            )
        }
    }


    return (
        <>
            <h3>Login</h3>
            <form action="">
                <input onChange={(e) => userSet(e.target.value)} value={user} type='text'/>
                <input onChange={(e) => passwordSet(e.target.value)} value={password} type='password'/>
                {error && <label>{error}</label>}
                <Link to='/signup'>Registrate</Link>
                <button onClick={validation}>
                    login
                </button>
            </form>
        </>
    )
}