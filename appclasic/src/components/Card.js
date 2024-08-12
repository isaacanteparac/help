import {card} from "@/utils/stringing";


export  default function Card(data) {
    return <div>
        <h4>{data.title}</h4>
        <p>{data.description}</p>
        <label>{card.name}</label>
    </div>
}