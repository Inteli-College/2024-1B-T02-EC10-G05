package db

import (
	"context"
	"fmt"
	"log"
	"os"

	"github.com/gin-gonic/gin"
	"github.com/penglongli/gin-metrics/ginmetrics"
	"github.com/redis/go-redis/v9"
	"gorm.io/driver/postgres"
	"gorm.io/gorm"
)



func SetupPostgres() *gorm.DB {

	dbHost := os.Getenv("DB_HOST")
	if dbHost == "" {
		log.Fatal("DB_HOST environment variable is not set.")
		os.Exit(1)
	}

	dsn := fmt.Sprintf("host=%s user=postgres password=admin123 dbname=postgres port=5432 sslmode=disable TimeZone=America/Sao_Paulo", dbHost)

	dbClient, err := gorm.Open(postgres.Open(dsn), &gorm.Config{})
	if err != nil {
		log.Fatal("Could not open database connection")
		os.Exit(1)
	}






	models := []interface{}{
		&Request{},
		&Product{},
		// &Report{},
		&User{},
		&Message{},
		// &Pixies{},
	}

	for _, model := range models {
		err = dbClient.AutoMigrate(model)
		if err != nil {
			log.Fatalf("Error migrating %v", model)
			os.Exit(1)
		}
	}

	fmt.Println(" -> Inicialização Postgres e Redis concluída")
	
	return dbClient
}

func SetupRedis( ) *redis.Client {
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

func SetupPrometheus(r *gin.Engine) {
	m := ginmetrics.GetMonitor()
	
	m.AddMetric(&ginmetrics.Metric{
		Type: 	ginmetrics.Counter,
		Name: "db_requests_operations_total",
		Description: "Total number of db requests operations",
		Labels:      []string{"label1"},
	})

	m.AddMetric(&ginmetrics.Metric{
		Type: 	ginmetrics.Counter,
		Name: "db_users_operations_total",
		Description: "Total number of db user operations",
		Labels:      []string{"label1"},
	})

	m.SetMetricPath("/metrics")
	m.Use(r)

}