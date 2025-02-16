####
###
## Manipulação de Análise de Dados em R
# "Acidentes de Trânsito em 2024" - Dados abertos da PRF


#Carregar bibliotecas 
library(dplyr)
library(tidyr)
library(ggplot2)

#Carregamento do arquivo .CSV 
df_tran <- read.csv("GitHub/FACULDADE/EstatisticaEProbabilidade/Portifolio/datatran2024.csv", sep=';',
                    encoding='latin1', fill=TRUE, check.names = FALSE)
# 'sep=' define que os dados estão separados por ';'
# encoding='latin1' define a codificação do texto
# fill=TRUE evita erros por falta colunas em linhas
# check.names - FALSE evita que o R renomeie as colunas automaticamente


#Cópia para trabalhar e manter arquivo original
datatran <- df_tran

##
#Gerar visualização aleatória de tabela de dados
View(head(datatran, 10))

##Criando tabelas por tipo
datatran_int <- datatran %>% select(where(is.numeric)) 
#tabela apenas com colunas do tipo INT
datatran_char <- datatran %>% select(where(is.character)) 
#tabela apenas com colunas do tipo CHAR


###VALORES NULOS
##Verificar se há valores nulos 
colSums(is.na(datatran))

##retornar valor nulo
linha_nulo <- datatran %>% filter(if_any(everything(), is.na))
head(linha_nulo)

##excluir valor nulo
datatran <- datatran %>% drop_na()

##checar se ainda há valores nulos
colSums(is.na(datatran))

##atualizar numero de linhas e colunas
str(datatran)


##Listar colunas por tipo
datatran_types <- tibble(
  Coluna = names(datatran),
  Tipo = sapply(datatran, class)
  )
print(datatran_types, n=30)


###
## FILTRAGEM, SUMARIZAÇÃO, CONTAGEM e outros

summary(datatran_int) # retorna sumário estatístico com medidas de tendência central (média e mediana) e 
#medidas de dispersão (mínimo e máximo, 1 e 2 interquartil) apenas das colunas do tipo integer

#correlação entre as variáveis numéricas
cor(datatran_int)

###
##Sumarização das pessoas envolvidas em acidentes
#somar número total de pessoas envolvidas
soma_pessoas <- sum(datatran$pessoas)
print(paste("Total de pessoas envolvidas em um acidente: ", soma_pessoas)) #156.252 pessoas
soma_feridos <- sum(datatran$feridos)
print(paste("Total de pessoas feridas: ", soma_feridos)) # 69.441 feridos
soma_feridos_leves <- sum(datatran$feridos_leves)
print(paste("Total de feridos leves: ", soma_feridos_leves)) # 52.686 feridos leves
soma_feridos_graves <- sum(datatran$feridos_graves)
print(paste("Total de feridos graves: ", soma_feridos_graves)) # 16.755 feridos graves
soma_mortos <- sum(datatran$mortos)
print(paste("Total de mortos: ", soma_mortos)) # 5.016 mortos
soma_ilesos <- sum(datatran$ilesos)
print(paste("Total de ilesos: ", soma_ilesos)) # 62.974 ilesos
soma_ignorados <- sum(datatran$ignorados)
print(paste("Total de ignorados, ", soma_ignorados)) # 24.255 ignorados


dados_acidente <- data.frame(
  Categoria = c("Total Envolvidos", "Feridos", "Feridos Leves", "Feridos Graves", 
                "Mortos", "Ilesos", "Ignorados"),
  Quantidade = c(156252, 69441, 52686, 16755, 5016, 62974, 24255)
)

##Criar gráfico de barras das pessoas envolvidas
ggplot(dados_acidente, aes(x = reorder(Categoria, Quantidade), y = Quantidade, fill = Categoria)) +
  geom_bar(stat = "identity") +
  coord_flip() +  
  theme_minimal() +
  labs(title = "Resumo das pessoas envolvidas em acidentes",
       x = "Categoria",
       y = "Quantidade") +
  scale_fill_manual(values = c("coral1", "firebrick4", "firebrick2", "gray", "lightgreen", "black", "lightblue")) +  
  geom_text(aes(label = format(Quantidade, big.mark = ".")), hjust = -0.2) 



##Gráfico de pizza com pessoas que não saíram ilesas ou ignoradas
dados_nao_ileso <- data.frame(
  Categoria = c("Feridos Leves", "Feridos Graves", 
                "Mortos"),
  Quantidade = c(52686, 16755, 5016))
  
ggplot(dados_nao_ileso, aes(x = "", y = Quantidade, fill = Categoria)) +
  geom_bar(stat = "identity", width = 1) +
  coord_polar("y", start = 0) +  
  theme_void() +
  labs(title = "Acidentes com Vítima") +
  scale_fill_manual(values = alpha(c("lightsalmon1", "navajowhite1", "orangered4"), alpha=0.8)) +  
  geom_text(aes(label = paste0(round((Quantidade/sum(Quantidade)) * 100, 1), "%")), 
            position = position_stack(vjust = 0.5), color="gray1",hjust=0.1, size = 5)

#chance de morrer em um acidente
chance_morrer <- soma_mortos / soma_pessoas
print(paste("A chance de morrer é de ", round(chance_morrer*100, 2), "%"))

#chance de sair ferido
chance_sair_ferido <- soma_feridos/ soma_pessoas
print(paste("A chance de se ferir em um acidente é de ", round(chance_sair_ferido*100, 2), "%"))

###

#ordenar condições meteorológicas por quantidade
datatran %>% 
  count(condicao_metereologica, name = 'Condições_Meteorológicas') %>% 
  arrange(desc(Condições_Meteorológicas))
#count() conta a frequência de cada condição meteorológica registrada na coluna
#arrange(desc()) ordena a frequência em por ordem descendente.

#filtro para retornar apenas os acidentes com vítimas fatais
datatran %>% 
  filter(classificacao_acidente == "Com Vítimas Fatais") %>% 
  count(condicao_metereologica, name="Contagem") %>% 
  arrange(desc(Contagem))


###PERGUNTAS
##Qual foi o estado com o maior número de acidentes?
estado_acidentes <- datatran %>% count(uf, name='contagem') %>% arrange(desc(contagem)) %>% slice(1)
print(paste("O estado com o maior número de mortos é", estado_acidentes$uf))

#criar gráfico
uf_acidentes <- data.frame(
  uf = c('MG', 'SC', 'PR', 'RJ', 'RS', 'SP', 'BA', 'GO', 'PE', 'MT'),
  n_acidentes = c(7597, 6916, 6213, 5236, 4320, 4035, 3443, 2775, 2682, 2131)
)

#definir cores do gráfico
cores <- ifelse(uf_acidentes$uf == "MG", "firebrick4", "indianred1")

#gráfico
ggplot(uf_acidentes, aes(x = reorder(uf, n_acidentes), y = n_acidentes, fill = uf)) +
  geom_bar(stat = "identity") +
  coord_flip() +  
  theme_minimal() +
  labs(title = "Estados com maior número de acidentes",
       x = "UF",
       y = "Quantidade de Acidentes") +
  scale_fill_manual(values = setNames(cores, uf_acidentes$uf)) +  
  geom_text(aes(label = format(n_acidentes, big.mark = ".")), hjust = -0.2, size = 4, fontface='bold') +
  theme(plot.title = element_text(size = 14, face = "bold", hjust = 0.5), legend.position = 'none')


#########
##Qual a probabilidade de um acidente ocorrer em condições climáticas claras?
#Número de acidentes com 'Céu claro' - 39.333
#Número total de acidentes - 60.365
total_acidente <- 60.365
ceu_claro_acidente <- 39.333
acidente_ceu_claro_prob <- ceu_claro_acidente / total_acidente
print(paste("A probabilidade de um acidente ocorrer em condições climáticas claras é de", round(acidente_ceu_claro_prob*100, 2), "%."))

###
##Como a fase do dia afeta a ocorrência de acidentes?
#contar e ordenar as ocorrências de fases do dia:
datatran %>% 
  count(fase_dia, name='fases_do_dia') %>% 
  arrange(desc(fases_do_dia))

#ordenar por horarios de maior ocorrência
datatran %>% 
  count(horario, name='horarios') %>% 
  arrange(desc(horarios)) %>% 
  head(15)

#Contar e ordenar dia da semana
datatran %>% 
  count(dia_semana, name='dia_da_semana') %>% 
  arrange(desc(dia_da_semana))

#filtrar luz do dia e repetir pesquisa
datatran %>% 
  filter(fase_dia == "Pleno dia") %>% 
  count(dia_semana, name='dia_da_semana_pleno_dia') %>% 
  arrange(desc(dia_da_semana_pleno_dia))

#filtrar para noite e repetir pesquisa
datatran %>% 
  filter(fase_dia == 'Plena Noite') %>% 
  count(dia_semana, name='dia_da_semana_plena_noite') %>% 
  arrange(desc(dia_da_semana_plena_noite))

#ordenar ocorrências por fase do dia apenas dos acidentes com vítimas fatiais
datatran %>% 
  filter(classificacao_acidente == 'Com Vítimas Fatais') %>% 
  count(fase_dia, name='fase_do_dia') %>% 
  arrange(desc(fase_do_dia))

#contar e ordenar as causas de acidentes
datatran %>% 
  count(causa_acidente, name='causas_acidente') %>% 
  arrange(desc(causas_acidente)) %>% 
  head


###
##Que insights podem ser gerados sobre os tipos de acidentes predominantes e suas causas?

datatran %>% 
  count(causa_acidente, tipo_acidente, name='frequencia') %>% 
  arrange(desc(frequencia))

#contar e ordenar tipos e causas dos acidentes em geral
datatran %>% 
  count(causa_acidente, name='causa_do_acidente') %>% 
  arrange(desc(causa_do_acidente)) %>% 
  head(15)
datatran %>% 
  count(tipo_acidente, name='tipo_do_acidente') %>% 
  arrange(desc(tipo_do_acidente)) %>% 
  head(15)

#contar e ordenar tipos e causas de acidentes apenas com vítimas fatais
datatran %>% 
  filter(mortos != 0) %>% 
  count(tipo_acidente, name='tipo_do_acidente') %>% 
  arrange(desc(tipo_do_acidente))
datatran %>% 
  filter(mortos != 0) %>% 
  count(causa_acidente, name='causa_do_acidente') %>% 
  arrange(desc(causa_do_acidente))