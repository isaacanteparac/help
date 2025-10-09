

export default function Button({text, action, style}){
    const modifier = style ? style : "bg-blue-400";
    return(
        <button className={`p-2 rounded-2xl w-28 ${modifier}`}  onClick={action}>
            {text}
        </button>
    );
}