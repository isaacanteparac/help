export default function Card(props) {
    const {species,name,gender,image} = props.data
    const style = {
        container: {
            display: "flex",
            flexDirection: "column",
            alignItems: "center",
            justifyContent: "center",
            padding: "20px",
            margin: "10px",
            border: "1px solid #ccc",
            borderRadius: "8px",
            boxShadow: "0 4px 8px rgba(0, 0, 0, 0.1)",
            backgroundColor: "#f9f9f9",
            width: "200px",
            textAlign: "center",
            fontFamily: "'Arial', sans-serif",
        },
        title: {
            fontSize: "18px",
            fontWeight: "bold",
            color: "#333",
            marginBottom: "10px",
        },
        label: {
            fontSize: "14px",
            color: "#555",
            marginBottom: "5px",
        },
        image:{
            width: '100px'
        }
    }
    return (
        <div style={style.container}>
            <h3 style={style.title}>{name}</h3>
            <label style={style.label}>{species}</label>
            <label style={style.label}>{gender}</label>
            <img style={style.image} src={image} content={name}/>
        </div>
    )
}