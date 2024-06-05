package main

import (
	"g5/server/controllers"
	"g5/server/db"
	"g5/server/middlewares"
	"g5/server/types"
	"github.com/gin-gonic/gin"
	"github.com/penglongli/gin-metrics/ginmetrics"
)

func main() {

	r := gin.Default()

	clients := types.Clients{
		Redis: db.SetupRedis(),
		Pg:    db.SetupPostgres(),
	}

	m := ginmetrics.GetMonitor()
	m.SetMetricPath("/metrics")
	m.Use(r)
	r.Use(m.AddMetric())

	r.Use(middlewares.AuthUser())
	r.Use(middlewares.AssertUserExistance(clients.Pg))

	controllers.InitReportRoutes(r, clients)
	controllers.InitRequestRoutes(r, clients)
	controllers.InitClientRoutes(r, clients)
	controllers.InitAdminRoutes(r, clients)

	r.Run(":8080")
}
