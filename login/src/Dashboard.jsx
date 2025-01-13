import {useNavigate} from "react-router-dom";
import {useEffect, useState} from "react";
import Card from "./Card.jsx";

export default function Dashboard() {
    const navigate = useNavigate()
    const [contentRandom, contentRandomSet] = useState([])
    const url = 'https://rickandmortyapi.com/api/character/?page=1'

    function logout() {
        localStorage.setItem('auth', JSON.stringify(false))
        navigate('/')
    }

    useEffect(() => {
        fetch(url).then(res => res.json()).then(response => {
            console.log(response.results)
            contentRandomSet(response.results)
        })
    }, [])


    return (
        <section>

            <h1>dashboard</h1>
            <button onClick={logout}>logout</button>
            <div>
                {contentRandom.map((it) =>(<Card key={it.id} data={it}/>))}
            </div>
        </section>
    )
}