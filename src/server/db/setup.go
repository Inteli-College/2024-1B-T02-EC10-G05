package db

import (
	"os"
	"fmt"
	"log"
	"context"
	"gorm.io/gorm"
	"gorm.io/driver/postgres"
	"github.com/redis/go-redis/v9"
)

func SetupPostgres() *gorm.DB {

	dbHost := os.Getenv("DB_HOST")
	if dbHost == "" {
		log.Fatal("DB_HOST environment variable is not set.")
		os.Exit(1)
	}

	dsn := fmt.Sprintf("host=%s user=postgres password=admin1234 dbname=postgres port=5432 sslmode=disable TimeZone=America/Sao_Paulo", dbHost)

	dbClient, err := gorm.Open(postgres.Open(dsn), &gorm.Config{})
	if err != nil {
		log.Fatal("Could not open database connection")
		os.Exit(1)
	}

	err = dbClient.AutoMigrate(&Request{})
	if err != nil {
		log.Fatal("Error migrating Request")
		os.Exit(1)
	}

	err = dbClient.AutoMigrate(&Product{})
	if err != nil {
		log.Fatal("Error migrating ItemType")
		os.Exit(1)
	}

	err = dbClient.AutoMigrate(&User{})
	if err != nil {
		log.Fatal("Error migrating User")
		os.Exit(1)
	}

	fmt.Println("Inicialização do banco de dados concluída")

	return dbClient
}

func SetupRedis() *redis.Client {
	redisHost := os.Getenv("REDIS_HOST")
	if redisHost == "" {
		log.Fatal("REDIS_HOST environment variable is not set.")
		os.Exit(1)
	}
	
	redisClient := redis.NewClient(&redis.Options{
		Addr: fmt.Sprintf("%s:6379", redisHost),
		DB:   0,
	})
	
	if _, err := redisClient.Ping(context.Background()).Result(); err != nil {
		log.Fatalf("Failed to connect to Redis: %v", err)
		os.Exit(1)
	}
	return redisClient
}