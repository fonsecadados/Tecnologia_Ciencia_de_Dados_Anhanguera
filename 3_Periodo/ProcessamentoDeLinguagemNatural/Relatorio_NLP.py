#Bibliotecas necessárias 
import nltk

from deep_translator import GoogleTranslator as gt #Biblioteca necessária para traduzir textos para o inglês
from nltk.chat.util import Chat, reflections #Biblioteca com ferramentas para Linguagem Natural
from textblob import TextBlob #Biblioteca de Análise de Sentimento


nltk.download('stopwords')
nltk.download('punkt')

#Perguntas Genéricas

pares = [
['Oi', ['Olá!', 'Olá, como vai?', 'Olá, como posso ajudar?']],
["Olá", ["Olá!"]],
['Como você está?', ['Estou bem, obrigado. E você?','Tudo ótimo!', 'Tudo bem!']],
['Tudo Bem?',['Tudo ótimo, e você, como vai?', 'Vou bem, e você?']],
["Vou bem também!",["Que bom! Como posso te ajudar?"]],
['Quem é você?', ['Sou seu professor virtual.', 'Me chame de Prof. Bot']],
['Bom dia', ['Bom dia! Como posso te ajudar hoje?', 'Bom dia! Tudo bem?']],
['Boa tarde', ['Boa tarde! Como vai você?', 'Boa tarde! Em que posso ajudar?']],
['Boa noite', ['Boa noite! Pronto para aprender algo novo?', 'Boa noite!']],
['Obrigado', ['De nada! Estou aqui para ajudar.', 'Por nada! Fico feliz em ajudar.']],
['Tchau', ['Até logo! Volte sempre.', 'Tchau! Foi bom conversar com você.']],
['Até mais', ['Até breve!', 'Nos falamos em breve!']],
['Qual é o seu objetivo?', ['Meu objetivo é ajudar a responder suas perguntas.', 'Estou aquipara te ensinar.']],
['Que tipo de pergunta posso fazer para você?',['Eu respondo perguntas sobre Ciência de Dados e \
                                                principalmente sobre Processamento de Linguagem Natural']],

#Perguntas sobre Ciência de Dados em geral
['O que é Ciência de Dados?',['Ciência de Dados é uma área que mistura programação, \
                              estatística e conhecimento de negócios para entender dados, \
                              descobrir padrões e tomar decisões inteligentes com base neles.']],

['Quais são as etapas de um projeto de Ciência de Dados?', 
 ['Coleta, limpeza, análise exploratória, modelagem, avaliação e comunicação dos resultados.']],

['Quais linguagens são usadas em Ciência de Dados?', 
 ['Python e R são as mais populares. Python é a mais usada no mercado.']],

['O que é análise exploratória de dados?', 
 ['É o processo de investigar os dados, encontrar padrões e entender melhor o \
  que está acontecendo antes de aplicar modelos.']],

['O que é machine learning?', 
 ['É uma área da inteligência artificial onde os computadores aprendem com \
  dados sem serem programados diretamente.']],

#Perguntas sobre Processamento de Linguagem Natural
['O que é Processamento de Linguagem Natural?',['PLN é a área da inteligência artificial que ensina \
                                                computadores a entender, interpretar e gerar linguagem humana']],

['O que é tokenização?', 
 ['É o processo de dividir um texto em palavras, frases ou outros elementos chamados tokens.']],

['O que são stopwords?', 
 ['São palavras comuns que geralmente são removidas, como "a", "o", "de", "e", etc.']],

['O que é análise de sentimento?', 
 ['É uma técnica que identifica se um texto expressa uma opinião positiva, negativa ou neutra.']],

['Qual a diferença entre stemming e lematização?', 
 ['Stemming reduz a palavra à raiz bruta. Lematização transforma em sua forma canônica ou dicionário.']],

]

chatbot = Chat(pares, reflections)

#Função para criar o chat
def chat():

    print("---")
    print("Olá! Digite 'sair' para encerrar o chat.")

    while True:

        mensagem = input("Você: ")
        if mensagem.lower() == 'sair':
            print('Chat encerrado')
            menu()
            break

        resposta = chatbot.respond(mensagem)
        if resposta:
            print("---")
            print("ChatBot: ", resposta)

        else:
            print("---")
            print("ChatBot: Desculpe, não entendi.")

       

#Função para analisar sentimento
def analisar_sentimento():

    try:
        print("-----")
        texto = input("Digite o texto:")
        traduzido = gt(source='pt', target='en').translate(texto)
        blob = TextBlob(traduzido)
        polaridade = blob.sentiment.polarity

        print(round(polaridade, 5))
        

        if polaridade > 0.0:
            print("Isso parece positivo! :)")
            looping()
        
        elif polaridade < 0.0:
            print("Isso parece negativo. :(")
            looping()
        else:
            print("Sentimento indeterminado")
            looping()
        
    except Exception as e:
        return f'Erro ao traduzir/analisar sentimento: {e}'

#Função para iniciar o programa
def menu():

        print("---")
        print("Bem Vindo! Escolha uma opção:")
        print("1: Conversar com ChatBot")
        print("2: Analisar sentimento")
        print(" ")
    
        while True:
            try:
                    
                escolha = int(input("Digite um número:"))
                if escolha == 1:
                    chat()
                    break
                elif escolha == 2:
                    analisar_sentimento()
                    looping()
                    break
                else:
                    print("Número inválido. Digite 1 ou 2")

            except ValueError:
                print("Digite número válido (1 ou 2)")

#Função Looping
def looping():

    print("---")
    print("1 - Analisar novamente")
    print("2 - Menu principal")

    num_escolha = int(input("Digite a opção: "))

    if num_escolha == 1:
        analisar_sentimento()
    elif num_escolha == 2:
        menu()

menu()
