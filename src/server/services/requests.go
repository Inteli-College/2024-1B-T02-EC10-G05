package services

import (
	"fmt"
	"g5/server/db"
	"g5/server/types"
	"github.com/gin-gonic/gin"
	"log"
)

func CreateRequest(
	c *gin.Context,
	clients types.Clients,
	userInternalId string,
	productCodes []uint,
	isUrgent bool,
	description string,
	PyxisID uint,
) {
	fmt.Println("Request received:", productCodes, isUrgent, description, PyxisID)
	fmt.Println("ProductCodes:", productCodes)
	fmt.Println("IsUrgent:", isUrgent)
	fmt.Println("Description:", description)
	fmt.Println("PixiesID:", PyxisID)
	fmt.Println("User:", userInternalId)

	if len(productCodes) == 0 && description == "" {
		c.JSON(400, gin.H{"error": "Pedido vazio. Adicione pelo menos a descrição ou um produto"})
		return
	}

	var user db.User
	if err := clients.Pg.Where("internal_id = ?", userInternalId).First(&user).Error; err != nil {
		c.JSON(500, gin.H{"error": "Usuário não encontrado (Isso não deveria acontecer)"})
		return
	}

	newRequest := db.Request{
		UserId:   user.ID,
		IsUrgent: isUrgent,
		PyxisID:  PyxisID,
	}

	if description != "" {
		newRequest.Description = description
	}


	var products []db.Product
	if err := clients.Pg.Where("code IN ?", productCodes).Find(&products).Error; err != nil {
		c.JSON(400, gin.H{"message": "failed to find products", "error": err})
		return
	}

	if len(products) != len(productCodes) {
		c.JSON(400, gin.H{"message": "Não foi possível encontrar todos os produtos. Verifique os códigos e tente novamente."})
		return
	}

	newRequest.Products = products

	// Salvar o novo Request no banco de dados
	if err := clients.Pg.Create(&newRequest).Error; err != nil {
		log.Fatalf("Erro ao criar o novo pedido: %v", err)
		c.JSON(500, gin.H{"error": "Erro ao criar o novo pedido"})
	}

	fmt.Println("Novo pedido criado com sucesso")
	c.JSON(201, gin.H{"message": "Pedido criado com sucesso", "request": newRequest})
}

func GetUserRequests(c *gin.Context, clients types.Clients) {
	var user db.User
	if err := clients.Pg.Where("internal_id = ?", c.GetString("user_internal_id")).First(&user).Error; err != nil {
		c.JSON(500, gin.H{"error": "Usuário não encontrado (Isso não deveria acontecer)"})
		return
	}

	var requests []db.Request
	if err := clients.Pg.Preload("Products").Where("user_id = ?", user.ID).Find(&requests).Error; err != nil {
		c.JSON(500, gin.H{"error": "Erro ao buscar pedidos do usuário"})
		return
	}

	c.JSON(200, requests)
}

func GetRequest(c *gin.Context, clients types.Clients, id string) {

	var request db.Request
	if err := clients.Pg.Preload("Products").Where("id = ?", id).First(&request).Error; err != nil {
		c.JSON(404, gin.H{"error": "Pedido não encontrado"})
		return
	}

	c.JSON(200, request)
}

func GetAllRequests(c *gin.Context, clients types.Clients) {
	var requests []db.Request
	if err := clients.Pg.Preload("Products").Find(&requests).Error; err != nil {
		c.JSON(500, gin.H{"error": "Erro ao buscar pedidos"})
		return
	}

	c.JSON(200, requests)
}

func GetAllMessages(c *gin.Context, clients types.Clients, id string) {
	var messages []db.Message
	if err := clients.Pg.Where("request_id = ?", id).Find(&messages).Error; err != nil {
		c.JSON(500, gin.H{"error": "Erro ao buscar mensagens"})
		return
	}

	c.JSON(200, messages)
}

// func FindNearestPixies(c *gin.Context, clients types.Clients, productCode string, currentPixiesName string) {
// 	var product db.Product
// 	if err := clients.Pg.Where("code = ?", productCode).First(&product).Error; err != nil {
// 		c.JSON(404, gin.H{"error": "Produto não encontrado"})
// 		return
// 	}

// 	var currentPixies db.Pixies
// 	if err := clients.Pg.Where("name = ?", currentPixiesName).First(&currentPixies).Error; err != nil {
// 		c.JSON(404, gin.H{"error": "Pixies atual não encontrada"})
// 		return
// 	}

// 	var pixies []db.Pixies
// 	if err := clients.Pg.Joins("JOIN pixies_products ON pixies_products.pixies_id = pixies.id").
// 		Where("pixies_products.product_id = ?", product.ID).Where("pixies.name != ?", currentPixiesName).Find(&pixies).Error; err != nil {
// 		c.JSON(500, gin.H{"error": "Erro ao buscar Pixies"})
// 		return
// 	}

// 	if len(pixies) == 0 {
// 		c.JSON(404, gin.H{"error": "Nenhuma Pixies encontrada com o produto solicitado"})
// 		return
// 	}

// 	closestPixies := pixies[0]
// 	minDistance := math.Abs(float64(closestPixies.Floor - currentPixies.Floor))

// 	for _, p := range pixies[1:] {
// 		distance := math.Abs(float64(p.Floor - currentPixies.Floor))
// 		if distance < minDistance {
// 			closestPixies = p
// 			minDistance = distance
// 		}
// 	}

// 	c.JSON(200, gin.H{
// 		"message": fmt.Sprintf("A Pixies mais próxima com o medicamento é: %s", closestPixies.Name),
// 		"pixies":  closestPixies.Name,
// 	})
// }
