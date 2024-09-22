package middlewares

import (
	"crypto/sha1"
	"fmt"
	"g5/server/db"
	"github.com/gin-gonic/gin"
	"gorm.io/gorm"
	"net/http"
	"github.com/penglongli/gin-metrics/ginmetrics"
)

// Verificar o token de autenticação do usuário contra a API de autenticação
func AuthUser() gin.HandlerFunc {
	return func(c *gin.Context) {
		token := c.GetHeader("Authorization")
		if token == "" {
			ginmetrics.GetMonitor().GetMetric("test_test_test").Inc([]string{"label1"});
			c.JSON(http.StatusUnauthorized, gin.H{"error": "Token de autenticação não fornecido"})
			c.Abort()
			return
		}

		hasher := sha1.New()
		hasher.Write([]byte(token))
		// adiciona os primeiros 6 caracteres do hash do token ao contexto
		c.Set("user_internal_id", fmt.Sprintf("%x", hasher.Sum(nil))[:6])

		contextId := c.GetString("user_internal_id")

		if contextId == "" {
			c.JSON(500, gin.H{"error": "Erro! O token de autenticação não foi encontrado no contexto da requisição."})
			c.Abort()
			return
		}

		fmt.Println(" \n-> [AuthUserMiddleware] Token de autenticação válido. token: ", token, " user_internal_id: ", contextId)
		c.Next()
	}
}

// Função que verifica se o usuário existe no nosso banco de dados. Se não existir, cria um novo usuário
func AssertUserExistance(pg *gorm.DB) gin.HandlerFunc {
	return func(c *gin.Context) {
		contextId := c.GetString("user_internal_id")

		if contextId == "" {
			c.JSON(500, gin.H{"error": "Erro! O token de autenticação não foi encontrado no contexto da requisição."})
			c.Abort()
			return
		}

		// Verifica se o usuário existe no banco de dados
		var user db.User
		if tx := pg.Where("internal_id = ?", contextId).First(&user); tx.Error != nil || tx.RowsAffected == 0 {
			fmt.Println("-> [AssertUserExistanceMiddleware] O usuário não existe no banco de dados. Criando... ", contextId)

			// Se o usuário não existir, cria um novo usuário
			user.InternalId = contextId
			pg.Create(&user)
			fmt.Println("-> [AssertUserExistanceMiddleware] Novo usuário criado. user_internal_id: ", contextId)
			c.Next()
			return

		} 

		fmt.Println("-> [AssertUserExistanceMiddleware] Usuário existe. ("+contextId+")")

		if user.IsAdmin {
			fmt.Println("-> [AssertUserExistanceMiddleware] Usuário é um administrador.")
			c.Set("is_admin", true)
		}

		c.Next()

	}
}

// Middleware que verifica se o usuário é um administrador
func IsAdmin() gin.HandlerFunc {
	return func(c *gin.Context) {
		isAdmin := c.GetBool("is_admin")
		if !isAdmin {
			c.JSON(403, gin.H{"error": "Você não tem permissão para acessar este recurso"})
			c.Abort()
			return
		}
		c.Next()
	}
}