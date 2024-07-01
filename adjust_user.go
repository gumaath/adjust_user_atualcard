package main

import (
	"bufio"
	"fmt"
	"os"
	//"regexp"
	"strings"
)

func main() {
	// Verifica se o número correto de argumentos foi fornecido
	if len(os.Args) < 4 {
		fmt.Println("Uso: go run programa.go arquivo.txt novo_valor_usr_web novo_valor_web_usr")
		os.Exit(1)
	}

	// Obtém os argumentos da linha de comando
	nomeArquivo := os.Args[1]
	novoValorUsrWeb := os.Args[2]
	novoValorWebUsr := os.Args[3]

	// Lê o conteúdo do arquivo
	conteudoArquivo, err := lerArquivo(nomeArquivo)
	if err != nil {
		fmt.Printf("Erro ao ler o arquivo: %v\n", err)
		os.Exit(1)
	}

	// Substitui os valores diretamente
	conteudoArquivo = strings.ReplaceAll(conteudoArquivo, "usr_web", novoValorUsrWeb)
	conteudoArquivo = substituirValor(conteudoArquivo, "web_usr", novoValorWebUsr)

	// Escreve o novo conteúdo de volta no arquivo
	err = escreverArquivo(nomeArquivo, conteudoArquivo)
	if err != nil {
		fmt.Printf("Erro ao escrever no arquivo: %v\n", err)
		os.Exit(1)
	}

	fmt.Printf("Valores atualizados com sucesso: usr_web = %s, web_usr = %s\n", novoValorUsrWeb, novoValorWebUsr)
}

func substituirValor(conteudo, alvo, novoValor string) string {
	return strings.ReplaceAll(conteudo, alvo, novoValor)
	// Check if the target value is surrounded by double quotes
	//re := regexp.MustCompile(`(['"])` + regexp.QuoteMeta(alvo) + `$1`)
	//if re.MatchString(conteudo) {
		// If it's surrounded by double quotes, replace the value
	//	return strings.ReplaceAll(conteudo, alvo, novoValor)
	//} else {
		// If it's not surrounded by double quotes, add them
	//	return strings.ReplaceAll(conteudo, alvo, `"`+novoValor+`"`)
	//}
}

func lerArquivo(nomeArquivo string) (string, error) {
	arquivo, err := os.Open(nomeArquivo)
	if err != nil {
		return "", err
	}
	defer arquivo.Close()

	var conteudo string
	scanner := bufio.NewScanner(arquivo)
	for scanner.Scan() {
		conteudo += scanner.Text() + "\n"
	}

	return conteudo, scanner.Err()
}

func escreverArquivo(nomeArquivo string, conteudo string) error {
	arquivo, err := os.Create(nomeArquivo)
	if err != nil {
		return err
	}
	defer arquivo.Close()

	writer := bufio.NewWriter(arquivo)
	_, err = writer.WriteString(conteudo)
	if err != nil {
		return err
	}

	return writer.Flush()
}
