package controllers

import (
	"fmt"
	"g5/server/services"
	"g5/server/types"
	"github.com/gin-gonic/gin"
)

func InitClientRoutes(r *gin.Engine, clients types.Clients) {
	client := r.Group("/client")
	{

		client.GET("/ping", func(c *gin.Context) {
			c.JSON(200, gin.H{"message": "Hello, clients!"})
		})

		client.POST("/updateUser", func(c *gin.Context) {
			var params services.UserUpdateParams

			if err := c.BindJSON(&params); err != nil {
				c.JSON(400, gin.H{"error": err.Error()})
				return
			}

			userID := c.GetString("user_internal_id")

			fmt.Println("--> updating user", userID)

			if err := services.UpdateUser(clients, userID, params); err != nil {
				c.JSON(500, gin.H{"error": err.Error()})
				return
			}

			c.JSON(200, gin.H{"message": "User updated successfully"})
		})

		client.GET("/getPreRequestData", func(c *gin.Context) {
			products, pyxis, err := services.GetPreRequestData(clients)
			if err != nil {
				c.JSON(500, gin.H{"error": err.Error()})
				return
			}
			c.JSON(200, gin.H{"products": products,"pyxis": pyxis})
		})
	}
}
