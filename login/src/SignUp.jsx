import {useState} from "react";
import {useNavigate} from "react-router-dom";

export default function SingUp() {
    const [user, userSet] = useState('')
    const [password, passwordSet] = useState('')
    const [error, errorSet] = useState('')
    const navigate = useNavigate()

    function register(e) {
        e.preventDefault()
        if (user || password) {
            let newUser = {
                user: user.toLowerCase(),
                password
            }
            localStorage.setItem('new_user', JSON.stringify(newUser))
            userSet('')
            passwordSet('')
            navigate('/')
        } else {
            errorSet("llene los campos")
            setTimeout(() => errorSet(''), 2000)
        }
    }

    return (
        <form>
            <h3>Sing Up</h3>
            <input type='text' placeholder={'user'} onChange={(e) => userSet(e.target.value)} value={user}/>
            <input type='password' placeholder={'password'} onChange={(e) => passwordSet(e.target.value)}
                   value={password}/>
            {error && <label>{error}</label>}
            <button onClick={register} type={"submit"}>
                sign up
            </button>
        </form>
    )
}