package main

import (
	"database/sql"
	"fmt"
	"github.com/gin-gonic/gin"
	_ "github.com/lib/pq"
	"golang.org/x/crypto/bcrypt"
	"log"
	"net/http"
	"os"
	"time"
)

type User struct {
	Email    string `json:"email"`
	Password string `json:"password"`
}

var db *sql.DB

func createTable() {
	const query = `
	CREATE TABLE IF NOT EXISTS users (
		id SERIAL PRIMARY KEY,
		email VARCHAR(255) NOT NULL,
		password VARCHAR(255) NOT NULL
	);`
	_, err := db.Exec(query)
	if err != nil {
		log.Fatalf("Failed to create table: %v", err)
	}
	log.Println("Table created or verified successfully")
}

func initDB() {

	host := os.Getenv("DB_HOST")
	if host == "" {
		log.Fatal("DB_HOST environment variable is not set.")
	}

	connStr := fmt.Sprintf("host=%s port=5432 user=postgres password=admin123 dbname=postgres sslmode=disable", host)

	var err error

	for i := 0; i <= 20; i++ {
		db, err = sql.Open("postgres", connStr)
		if err != nil {
			log.Printf("Failed to open database: %v", err)
			time.Sleep(5 * time.Second)
			continue
		}
		if err = db.Ping(); err != nil {
			log.Printf("Failed to connect to database: %v", err)
			time.Sleep(5 * time.Second)
			continue
		}
		createTable()
		log.Println("Connected to the database successfully")
		return
	}

	if err = db.Ping(); err != nil {
		log.Printf("[FATAL] Cannot connect to DB, exiting")
		os.Exit(1)
	}

}

func setupRouter() *gin.Engine {
	r := gin.Default()

	r.GET("/", func(c *gin.Context) {
		c.String(http.StatusOK, "Hello World!")
	})

	r.GET("/:name", func(c *gin.Context) {
		name := c.Params.ByName("name")
		c.String(http.StatusOK, "Hello, %s!", name)
	})

	r.POST("/users", func(c *gin.Context) {
		var newUser User
		if err := c.BindJSON(&newUser); err != nil {
			c.JSON(http.StatusBadRequest, gin.H{"error": "Invalid data"})
			return
		}

		hashedPassword, err := bcrypt.GenerateFromPassword([]byte(newUser.Password), bcrypt.DefaultCost)
		if err != nil {
			c.JSON(http.StatusInternalServerError, gin.H{"error": "Could not hash password"})
			return
		}

		_, err = db.Exec("INSERT INTO users (email, password) VALUES ($1, $2)", newUser.Email, string(hashedPassword))
		if err != nil {
			c.JSON(http.StatusInternalServerError, gin.H{"error": "Could not save user"})
			return
		}

		c.JSON(http.StatusCreated, gin.H{"status": "User created"})
	})

	return r
}

func main() {
	initDB()
	r := setupRouter()
	r.Run(":8080")
}
