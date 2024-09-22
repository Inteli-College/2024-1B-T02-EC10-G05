package services

import (
	"g5/server/db"
	"g5/server/types"
)

type UserUpdateParams struct {
	Name     *string `json:"name"`
	Email    *string `json:"email"`
	Position *string `json:"position"`
}

func GetPreRequestData(clients types.Clients) ([]db.Product, []db.Pyxis, error) {

	var products []db.Product

	tx := clients.Pg.Find(&products)

	if tx.Error != nil {
		return []db.Product{}, []db.Pyxis{}, tx.Error
	}


	var pyxis []db.Pyxis

	tx = clients.Pg.Find(&pyxis)

	if tx.Error != nil {
		return []db.Product{}, []db.Pyxis{}, tx.Error
	}

	return products, pyxis, nil

}

func UpdateUser(clients types.Clients, userInternalId string, params UserUpdateParams) error {

	updateData := make(map[string]interface{})

	if params.Name != nil {
		updateData["name"] = *params.Name
	}

	if params.Email != nil {
		updateData["email"] = *params.Email
	}

	if params.Position != nil {
		updateData["position"] = *params.Position
	}

	return clients.Pg.Model(&db.User{}).Where("internal_id = ?", userInternalId).Updates(updateData).Error
}
