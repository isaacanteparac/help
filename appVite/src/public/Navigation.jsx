import { Link } from "react-router-dom";

export default function Navigation() {

    return (
        <nav className="flex gap-4 p-4 bg-gray-800 text-white">
            <Link to="/">Home</Link>
            <Link to="/practica">Practica2</Link>
        </nav>
    );

}