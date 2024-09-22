package controllers

import (
	mw "g5/server/middlewares"
	"g5/server/services"
	"g5/server/types"
	"github.com/gin-gonic/gin"
)

type createProductBody struct {
	Name string `json:"name"`
	Code string `json:"code"`
}

type makeAdminBody struct {
	Email string `json:"email"`
}

func InitAdminRoutes(r *gin.Engine, clients types.Clients) {
	admin := r.Group("/admin")
	{

		admin.GET("/ping", mw.IsAdmin(), func(c *gin.Context) {
			c.JSON(200, "Hello, Admin!")
		})

		admin.POST("/makeAdmin", mw.IsAdmin(), func(c *gin.Context) {

			var req makeAdminBody
			if err := c.BindJSON(&req); err != nil {
				c.JSON(400, gin.H{"error": err.Error()})
				return
			}

			if err := services.MakeAdmin(clients, req.Email); err != nil {
				c.JSON(500, gin.H{"error": err.Error()})
				return
			}

			c.JSON(200, gin.H{"message": "user promoted to admin"})
		})
	}
}
