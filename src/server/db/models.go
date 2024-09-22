package db

import (
	"github.com/penglongli/gin-metrics/ginmetrics"
	"gorm.io/gorm"
)

// Usuarios
// InternalId é o id do usuário no sistema de autenticação do sirio
// Esse ID já passou pelo middleware de autenticação, então podemos confiar nele
// Portanto, gostaria de lembrar que não precisamos salvar a senha do usuário no banco de dados
type User struct {
	gorm.Model
	InternalId string `gorm:"unique;not null"`
	Name       string
	Requests   []Request
	Messages   []Message
	IsAdmin    bool `gorm:"default:false"` // true se o usuário é da central, false se é um usuário comum
}

// Pedidos
type Request struct {
	gorm.Model
	UserId      uint
	User        User
	Description string
	Status      Status `gorm:"default:1"`
	IsUrgent    bool `gorm:"default:false"`
	Messages    []Message
	PyxisID     uint
	Pyxis       Pyxis
	Products []Product `gorm:"many2many:request_products;"`
}

type Status int

const (
	Waiting Status = iota + 1
	InProgress
	Finished
)

// Produto (Equipamentos, insumos, remédios, etc.)
type Product struct {
	gorm.Model
	Name string `gorm:"not null"`
	Code int `gorm:"unique;not null"` // Código do item (código de barras?)
}

// Mensagem
type Message struct {
	gorm.Model
	RequestID  uint
	Request    Request
	Content    string
	SentByUser bool // true se a mensagem foi enviada pelo usuário, false se foi enviada pela central
	UserID     uint
	User       User
}

type Pyxis struct {
	gorm.Model
	Name     string `gorm:"not null"`
}

func (u *User) AfterSave(tx *gorm.DB) (err error) {
	ginmetrics.GetMonitor().GetMetric("db_users_operations_total").Inc([]string{"label1"})
	return
}

func (r *Request) AfterSave(tx *gorm.DB) (err error){
	ginmetrics.GetMonitor().GetMetric("db_requests_operations_total").Inc([]string{"label1"})
	return
}
