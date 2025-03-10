use actix_web::{get, App, HttpServer, Responder, HttpResponse};
use std::env;

#[get("/")]
async fn index() -> impl Responder {
    HttpResponse::Ok().body("🚀 Hello from Rust! The server is running successfully.")
}

#[actix_web::main]
async fn main() -> std::io::Result<()> {
    // الحصول على رقم المنفذ من المتغير البيئي في Render
    let port = env::var("PORT").unwrap_or_else(|_| "8080".to_string());
    let port: u16 = port.parse().expect("Invalid PORT number");

    println!("🚀 Server is running on port {}", port);

    HttpServer::new(|| App::new().service(index))
        .bind(("0.0.0.0", port))?
        .run()
        .await
}
