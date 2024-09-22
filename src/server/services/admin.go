package services

import (
	"g5/server/db"
	"g5/server/types"
	// "context"
)

// func CreateProduct(clients types.Clients, productName string, productCode string) (string, error) {

// 	product := db.Product{
// 		Name: productName,
// 		Code: productCode,
// 	}

// 	tx := clients.Pg.Create(&product)

// 	if tx.Error != nil {
// 		return "", tx.Error
// 	}

// 	// limpa o cache de produtos, para que a próxima requisição busque os dados atualizados
// 	go clients.Redis.Del(context.Background(), "products")

// 	return "success", nil
// }

func MakeAdmin(clients types.Clients, email string) error {
	
	var user db.User

	tx := clients.Pg.Where("email = ?", email).First(&user)

	if tx.Error != nil {
		return tx.Error
	}

	user.IsAdmin = true

	tx = clients.Pg.Save(&user)

	if tx.Error != nil {
		return tx.Error
	}

	return nil
}