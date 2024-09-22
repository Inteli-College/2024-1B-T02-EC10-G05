package controllers

import (
	"fmt"
	mw "g5/server/middlewares"
	"g5/server/services"
	"g5/server/types"
	"github.com/gin-gonic/gin"
	"github.com/go-playground/validator/v10"
)

type createRequestBody struct {
	ProductCodes    []uint `json:"productCodes"`
	Urgent      bool   `json:"urgent"`
	Description string `json:"description"`
	PyxisID    uint   `json:"pyxisID" validate:"required"`
}

func InitRequestRoutes(r *gin.Engine, clients types.Clients) {

	requests := r.Group("/request")
	{

		requests.POST("/create", func(c *gin.Context) {
			
			user, _ := c.Get("user_internal_id")

			var req createRequestBody

			if err := c.BindJSON(&req); err != nil {
				c.JSON(400, gin.H{"error": err.Error()})
				return
			}

			validate := validator.New()

			if err := validate.Struct(req); err != nil {
				c.JSON(400, gin.H{"error": err.Error()})
				return
			}

			fmt.Println("Request received:", req)

			services.CreateRequest(
				c,
				clients,
				user.(string),
				req.ProductCodes,
				req.Urgent,
				req.Description,
				req.PyxisID,
			)

		})

		requests.GET("/user", func(c *gin.Context) {
			services.GetUserRequests(c, clients)
		})

		requests.GET("/get/:id", func(c *gin.Context) {
			services.GetRequest(c, clients, c.Param("id"))
		})

		requests.GET("/getAll", mw.IsAdmin(), func(c *gin.Context) {
			services.GetAllRequests(c, clients)
		})

		// Retorna as mensagens do chat de um request
		// Essa rota retorna as mensagens PASSADAS. O envio e recebiemnto de mensagens em tempo real é feito pelo WebSocket
		requests.GET("/:id/messages", func(c *gin.Context) {
			services.GetAllMessages(c, clients, c.Param("id"))
		})

		// requests.POST("/findPixies", func(c *gin.Context) {
		// 	var req findPixiesRequestBody

		// 	if err := c.BindJSON(&req); err != nil {
		// 		c.JSON(400, gin.H{"error": err.Error()})
		// 		return
		// 	}

		// 	fmt.Println("Find Pixies request received:", req)

		// 	services.FindNearestPixies(c, clients, req.ProductCode, req.CurrentPixies)
		// })

	}
}
