import {  useEffect, useState } from "react";
import Button from "../componets/buttons/Button";


export default function Practica() {
    const http = "https://rickandmortyapi.com/api/character/"
    const [getCount, setCount] = useState(0);
    const [data, setData] = useState([]);
    const page = `${http}?page=${getCount}`;
    const [loading, setLoading] = useState(false);
    const [error, setError] = useState("");

    const nextPage =  ()=> {
        if (getCount < 42) {
            setCount(getCount + 1);
        }
    }
    const previousPage = () => {
        if (getCount >= 0) {
            setCount(getCount - 1);
        }
    }

    const dataFetch = async (url) => {
        setLoading(true);
        try {
            const res = await fetch(url);
            if (!res.ok) throw new Error("Error al cargar los datos");
            const json = await res.json();
            setData(json.results);
        } catch (error) {
            setError(error.message);
        } finally {
            setLoading(false);
        }
    }

    useEffect(() => {
        dataFetch(page);
    }, [page])
    // se ejecuta por primera al montar el componente
    //[]add un state y se ejecuta cada vez que cambia ese state
    // tambien se puede usar para limpiar recursos
    // return () => {} se ejecuta al desmontar el componente

    if (loading) return <h1>Cargando...</h1>
    if (error) return <h1>{`Error: ${error}`}</h1>

    return (
        <div className="flex flex-col justify-center items-center gap-5 font-yellow-300 scroll-auto">
            <h1>{getCount}</h1>
            <Button text="<" action={previousPage} style="bg-yellow-300  text-black font-bold" />

            <Button text=">" action={nextPage} style="bg-yellow-300  text-black font-bold" />
            <ul>
                {data.map(item => <li key={item.id}>{item.id} | {item.name} | {item.status}</li>)}
            </ul>

        </div>


    );
}
