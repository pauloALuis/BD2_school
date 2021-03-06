USE [master]
GO
/****** Object:  Database [GestEscolar01]    Script Date: 19/04/2021 23:52:52 ******/
CREATE DATABASE [GestEscolar01]
 CONTAINMENT = NONE
 ON  PRIMARY 
( NAME = N'Dados_1', FILENAME = N'C:\Users\AlunoETLA\Documents\BD\C_BD\Dados_1.mdf' , SIZE = 12288KB , MAXSIZE = UNLIMITED, FILEGROWTH = 15%),
( NAME = N'Dados_2', FILENAME = N'C:\Users\AlunoETLA\Documents\BD\C_BD\Dados_2.ndf' , SIZE = 12288KB , MAXSIZE = UNLIMITED, FILEGROWTH = 10%), 
 FILEGROUP [DadosCorrentes_1] 
( NAME = N'Dados_3', FILENAME = N'C:\Users\AlunoETLA\Documents\BD\D_BD\Dados_3.ndf' , SIZE = 12288KB , MAXSIZE = UNLIMITED, FILEGROWTH = 15%),
( NAME = N'Dados_4', FILENAME = N'C:\Users\AlunoETLA\Documents\BD\D_BD\Dados_4.ndf' , SIZE = 12288KB , MAXSIZE = UNLIMITED, FILEGROWTH = 15%), 
 FILEGROUP [FileGroup_Indeces] 
( NAME = N'Dados_5', FILENAME = N'C:\Users\AlunoETLA\Documents\BD\D_BD\Dados_5.ndf' , SIZE = 102400KB , MAXSIZE = UNLIMITED, FILEGROWTH = 10%)
 LOG ON 
( NAME = N'Logs_1', FILENAME = N'C:\Users\AlunoETLA\Documents\BD\E_BD\Logs_1.ldf' , SIZE = 10240KB , MAXSIZE = 2048GB , FILEGROWTH = 10%), 
( NAME = N'Logs_2', FILENAME = N'C:\Users\AlunoETLA\Documents\BD\E_BD\Logs_2.ldf' , SIZE = 10240KB , MAXSIZE = 2048GB , FILEGROWTH = 10%)
GO
ALTER DATABASE [GestEscolar01] SET COMPATIBILITY_LEVEL = 130
GO
IF (1 = FULLTEXTSERVICEPROPERTY('IsFullTextInstalled'))
begin
EXEC [GestEscolar01].[dbo].[sp_fulltext_database] @action = 'enable'
end
GO
ALTER DATABASE [GestEscolar01] SET ANSI_NULL_DEFAULT OFF 
GO
ALTER DATABASE [GestEscolar01] SET ANSI_NULLS OFF 
GO
ALTER DATABASE [GestEscolar01] SET ANSI_PADDING OFF 
GO
ALTER DATABASE [GestEscolar01] SET ANSI_WARNINGS OFF 
GO
ALTER DATABASE [GestEscolar01] SET ARITHABORT OFF 
GO
ALTER DATABASE [GestEscolar01] SET AUTO_CLOSE OFF 
GO
ALTER DATABASE [GestEscolar01] SET AUTO_SHRINK OFF 
GO
ALTER DATABASE [GestEscolar01] SET AUTO_UPDATE_STATISTICS ON 
GO
ALTER DATABASE [GestEscolar01] SET CURSOR_CLOSE_ON_COMMIT OFF 
GO
ALTER DATABASE [GestEscolar01] SET CURSOR_DEFAULT  GLOBAL 
GO
ALTER DATABASE [GestEscolar01] SET CONCAT_NULL_YIELDS_NULL OFF 
GO
ALTER DATABASE [GestEscolar01] SET NUMERIC_ROUNDABORT OFF 
GO
ALTER DATABASE [GestEscolar01] SET QUOTED_IDENTIFIER OFF 
GO
ALTER DATABASE [GestEscolar01] SET RECURSIVE_TRIGGERS OFF 
GO
ALTER DATABASE [GestEscolar01] SET  ENABLE_BROKER 
GO
ALTER DATABASE [GestEscolar01] SET AUTO_UPDATE_STATISTICS_ASYNC OFF 
GO
ALTER DATABASE [GestEscolar01] SET DATE_CORRELATION_OPTIMIZATION OFF 
GO
ALTER DATABASE [GestEscolar01] SET TRUSTWORTHY OFF 
GO
ALTER DATABASE [GestEscolar01] SET ALLOW_SNAPSHOT_ISOLATION OFF 
GO
ALTER DATABASE [GestEscolar01] SET PARAMETERIZATION SIMPLE 
GO
ALTER DATABASE [GestEscolar01] SET READ_COMMITTED_SNAPSHOT OFF 
GO
ALTER DATABASE [GestEscolar01] SET HONOR_BROKER_PRIORITY OFF 
GO
ALTER DATABASE [GestEscolar01] SET RECOVERY FULL 
GO
ALTER DATABASE [GestEscolar01] SET  MULTI_USER 
GO
ALTER DATABASE [GestEscolar01] SET PAGE_VERIFY CHECKSUM  
GO
ALTER DATABASE [GestEscolar01] SET DB_CHAINING OFF 
GO
ALTER DATABASE [GestEscolar01] SET FILESTREAM( NON_TRANSACTED_ACCESS = OFF ) 
GO
ALTER DATABASE [GestEscolar01] SET TARGET_RECOVERY_TIME = 60 SECONDS 
GO
ALTER DATABASE [GestEscolar01] SET DELAYED_DURABILITY = DISABLED 
GO
ALTER DATABASE [GestEscolar01] SET QUERY_STORE = OFF
GO
USE [GestEscolar01]
GO
ALTER DATABASE SCOPED CONFIGURATION SET LEGACY_CARDINALITY_ESTIMATION = OFF;
GO
ALTER DATABASE SCOPED CONFIGURATION FOR SECONDARY SET LEGACY_CARDINALITY_ESTIMATION = PRIMARY;
GO
ALTER DATABASE SCOPED CONFIGURATION SET MAXDOP = 0;
GO
ALTER DATABASE SCOPED CONFIGURATION FOR SECONDARY SET MAXDOP = PRIMARY;
GO
ALTER DATABASE SCOPED CONFIGURATION SET PARAMETER_SNIFFING = ON;
GO
ALTER DATABASE SCOPED CONFIGURATION FOR SECONDARY SET PARAMETER_SNIFFING = PRIMARY;
GO
ALTER DATABASE SCOPED CONFIGURATION SET QUERY_OPTIMIZER_HOTFIXES = OFF;
GO
ALTER DATABASE SCOPED CONFIGURATION FOR SECONDARY SET QUERY_OPTIMIZER_HOTFIXES = PRIMARY;
GO
USE [GestEscolar01]
GO
/****** Object:  User [user_Docentes]    Script Date: 19/04/2021 23:52:53 ******/
CREATE USER [user_Docentes] FOR LOGIN [login_Docentes] WITH DEFAULT_SCHEMA=[dbo]
GO
/****** Object:  User [user_Docente]    Script Date: 19/04/2021 23:52:53 ******/
CREATE USER [user_Docente] WITHOUT LOGIN WITH DEFAULT_SCHEMA=[Docentes]
GO
/****** Object:  Schema [Aluno_Encarregado]    Script Date: 19/04/2021 23:52:53 ******/
CREATE SCHEMA [Aluno_Encarregado]
GO
/****** Object:  Schema [Docentes]    Script Date: 19/04/2021 23:52:53 ******/
CREATE SCHEMA [Docentes]
GO
/****** Object:  Schema [Geral]    Script Date: 19/04/2021 23:52:53 ******/
CREATE SCHEMA [Geral]
GO
/****** Object:  UserDefinedFunction [dbo].[check_LimeteConsumoDiario]    Script Date: 19/04/2021 23:52:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[check_LimeteConsumoDiario] (@DataInput VARCHAR(20), @CodAluno NVARCHAR(10), @valor DECIMAL (18,2), @BLK BIT )
RETURNS BIT
AS BEGIN
		DECLARE @RESULT DECIMAL (18,2)
		SET @RESULT = (SELECT SUM (valor_mov) FROM Aluno_Encarregado.Movimentos WHERE Tipo_Operacao LIKE '%Debito%' AND Data_Mov = @DataInput ) 
	
	--VERIFICA SE O LIMITE DIARIO DO CARTÃO FOI EXCEDIDO - SE SIM ENTÃO RETOMA
		IF( @RESULT >= @valor + (SELECT limite_consumo FROM Aluno_Encarregado.Cartao where ID_Codigo LIKE @CodAluno) AND @BLK LIKE 1 )
		  	RETURN 1
		

   RETURN 0
END
GO
/****** Object:  Table [Aluno_Encarregado].[Aluno]    Script Date: 19/04/2021 23:52:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Aluno_Encarregado].[Aluno](
	[ID_Codigo] [nvarchar](10) NOT NULL,
	[ID_Encarregado_educacao] [nvarchar](10) NOT NULL,
	[ID_Turma] [nvarchar](10) NULL,
	[Nome_Completo] [nvarchar](100) NULL,
	[Num_Identificacao] [nvarchar](20) NULL,
	[Contato_telefonico] [nvarchar](50) NULL,
	[Data_Nascimento] [smalldatetime] NULL,
	[Data_Inscricao] [smalldatetime] NULL,
	[Nacionalidade] [nvarchar](10) NULL,
 CONSTRAINT [PK__Aluno__49EDC37D2F550332] PRIMARY KEY CLUSTERED 
(
	[ID_Codigo] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [Aluno_Encarregado].[Cartao]    Script Date: 19/04/2021 23:52:55 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Aluno_Encarregado].[Cartao](
	[ID_Codigo] [nvarchar](10) NOT NULL,
	[Data__Criacao] [smalldatetime] NULL,
	[Saldo] [decimal](18, 2) NULL,
	[Limite_Consumo] [decimal](18, 2) NULL,
 CONSTRAINT [PK__Cartao__49EDC37D3B3348C1] PRIMARY KEY CLUSTERED 
(
	[ID_Codigo] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [Aluno_Encarregado].[Encarregado_Educacao]    Script Date: 19/04/2021 23:52:55 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Aluno_Encarregado].[Encarregado_Educacao](
	[ID_Encarregado] [nvarchar](10) NOT NULL,
	[Nome] [nvarchar](100) NULL,
	[Morada] [nvarchar](100) NULL,
	[Num_Docum] [nvarchar](50) NULL,
	[Contato_telefonico] [bigint] NULL,
	[GRAU_Parentesco] [nvarchar](100) NULL,
 CONSTRAINT [PK__Encarreg__BE8EB01C6E866644] PRIMARY KEY CLUSTERED 
(
	[ID_Encarregado] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [Aluno_Encarregado].[Movimentos]    Script Date: 19/04/2021 23:52:56 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Aluno_Encarregado].[Movimentos](
	[ID_Movimentos] [nvarchar](10) NOT NULL,
	[ID_Codigo] [nvarchar](10) NULL,
	[Tipo_Mov] [nvarchar](50) NULL,
	[Local_Mov] [nvarchar](50) NULL,
	[Data_Mov] [date] NULL,
	[ID_Refeicao] [nvarchar](10) NULL,
	[Valor_Mov] [decimal](18, 2) NULL,
	[Tipo_Operacao] [nvarchar](10) NULL,
PRIMARY KEY CLUSTERED 
(
	[ID_Movimentos] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[TB_Login_user]    Script Date: 19/04/2021 23:52:56 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[TB_Login_user](
	[ID_user] [smallint] IDENTITY(1,1) NOT NULL,
	[login_user] [varchar](40) NULL,
	[password_user] [nvarchar](20) NULL,
PRIMARY KEY CLUSTERED 
(
	[ID_user] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [Docentes].[Disciplina]    Script Date: 19/04/2021 23:52:56 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Docentes].[Disciplina](
	[ID_Disciplina] [nvarchar](10) NOT NULL,
	[Num_Horas_Total] [int] NULL,
	[Designacao] [nvarchar](50) NULL,
	[Curso] [nvarchar](50) NULL,
 CONSTRAINT [PK__Discipli__CC42714D1E75FD59] PRIMARY KEY CLUSTERED 
(
	[ID_Disciplina] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [DadosCorrentes_1]
) ON [DadosCorrentes_1]
GO
/****** Object:  Table [Docentes].[Disciplina_Docente]    Script Date: 19/04/2021 23:52:56 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Docentes].[Disciplina_Docente](
	[ID_Disc_Doce] [nvarchar](10) NOT NULL,
	[ID_Disciplina] [nvarchar](10) NULL,
	[ID_Docente] [nvarchar](10) NULL,
PRIMARY KEY CLUSTERED 
(
	[ID_Disc_Doce] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [DadosCorrentes_1]
) ON [DadosCorrentes_1]
GO
/****** Object:  Table [Docentes].[Docente]    Script Date: 19/04/2021 23:52:56 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Docentes].[Docente](
	[ID_Docente] [nvarchar](10) NOT NULL,
	[Nome_Docente] [nvarchar](80) NOT NULL,
	[Dt_Nascimento] [smalldatetime] NOT NULL,
	[Num_Documento] [nvarchar](50) NOT NULL,
	[Morada_Docente] [nvarchar](100) NULL,
	[Tipo_Curso] [nvarchar](100) NULL,
	[Grau_Escolaridade] [nvarchar](80) NULL,
	[Escalao] [nvarchar](80) NULL,
 CONSTRAINT [PK__Docente__51C8FDABDAF490DE] PRIMARY KEY CLUSTERED 
(
	[ID_Docente] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [DadosCorrentes_1]
) ON [DadosCorrentes_1]
GO
/****** Object:  Table [Geral].[Aulas]    Script Date: 19/04/2021 23:52:56 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Geral].[Aulas](
	[ID_Aula] [nvarchar](10) NOT NULL,
	[ID_Disciplina] [nvarchar](10) NULL,
	[Data_aula] [date] NULL,
	[Estado] [nvarchar](50) NULL,
	[Sala] [nvarchar](20) NULL,
	[Sumario_Aula] [nvarchar](500) NULL,
	[hora_inicio] [decimal](18, 2) NULL,
	[hora_fim] [decimal](18, 2) NULL,
	[Periodo] [nvarchar](10) NULL,
 CONSTRAINT [PK__Aulas__4F5B06E922266741] PRIMARY KEY CLUSTERED 
(
	[ID_Aula] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [DadosCorrentes_1]
) ON [DadosCorrentes_1]
GO
/****** Object:  Table [Geral].[Avaliacoes]    Script Date: 19/04/2021 23:52:57 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Geral].[Avaliacoes](
	[ID_Avaliacoes] [nvarchar](10) NOT NULL,
	[ID_Codigo] [nvarchar](10) NULL,
	[ID_Disciplina] [nvarchar](10) NULL,
	[Tipo_Avaliacao] [nvarchar](50) NULL,
	[Periodo] [nvarchar](10) NULL,
	[Ano_letivo] [nvarchar](10) NULL,
	[Nota_teste] [decimal](18, 2) NULL,
	[Percentagem_Nota] [decimal](18, 2) NULL,
 CONSTRAINT [PK__Avaliaco__1A7CF66FE7FED5D2] PRIMARY KEY CLUSTERED 
(
	[ID_Avaliacoes] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [DadosCorrentes_1]
) ON [DadosCorrentes_1]
GO
/****** Object:  Table [Geral].[Ementas_Dia]    Script Date: 19/04/2021 23:52:57 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Geral].[Ementas_Dia](
	[ID_Refeicao] [nvarchar](10) NOT NULL,
	[Data_dia] [smalldatetime] NULL,
	[Hora_Inicio] [time](7) NULL,
	[Prato_Principal] [nvarchar](30) NULL,
	[Sopa] [nvarchar](30) NULL,
	[Sobremesa] [nvarchar](30) NULL,
	[Calorias] [nvarchar](30) NULL,
	[Preco] [smallmoney] NULL,
	[Num_senhas] [int] NULL,
 CONSTRAINT [PK__Ementas___F67C97B7F991F34F] PRIMARY KEY CLUSTERED 
(
	[ID_Refeicao] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [Geral].[Faltas]    Script Date: 19/04/2021 23:52:57 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Geral].[Faltas](
	[ID_Falta] [nvarchar](10) NOT NULL,
	[ID_Codigo] [nvarchar](10) NULL,
	[ID_Aula] [nvarchar](10) NULL,
	[Tipo_Falta] [nvarchar](10) NULL,
	[Doc_Justificacao] [image] NULL,
	[Estado_Justificacao] [nvarchar](30) NULL,
	[Data_Justificacao] [date] NULL,
PRIMARY KEY CLUSTERED 
(
	[ID_Falta] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [DadosCorrentes_1]
) ON [DadosCorrentes_1] TEXTIMAGE_ON [DadosCorrentes_1]
GO
/****** Object:  Table [Geral].[Turma]    Script Date: 19/04/2021 23:52:57 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Geral].[Turma](
	[ID_Turma] [nvarchar](10) NOT NULL,
	[Designacao_Turma] [nvarchar](80) NULL,
	[Num_Inscritos] [decimal](18, 2) NULL,
	[Ano_Lectivo] [nvarchar](50) NULL,
 CONSTRAINT [PK_Turma] PRIMARY KEY CLUSTERED 
(
	[ID_Turma] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [DadosCorrentes_1]
) ON [DadosCorrentes_1]
GO
/****** Object:  Table [Geral].[Turma_Aulas]    Script Date: 19/04/2021 23:52:57 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Geral].[Turma_Aulas](
	[ID_Turma_Aula] [nvarchar](10) NOT NULL,
	[ID_Turma] [nvarchar](10) NULL,
	[ID_Aula] [nvarchar](10) NULL,
PRIMARY KEY CLUSTERED 
(
	[ID_Turma_Aula] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [DadosCorrentes_1]
) ON [DadosCorrentes_1]
GO
ALTER TABLE [Geral].[Turma] ADD  CONSTRAINT [DF_Turma_Num_Inscritos]  DEFAULT ((0)) FOR [Num_Inscritos]
GO
ALTER TABLE [Geral].[Turma] ADD  CONSTRAINT [DF_Turma_Ano_Lectivo]  DEFAULT ((2018)/(2019)) FOR [Ano_Lectivo]
GO
ALTER TABLE [Aluno_Encarregado].[Aluno]  WITH CHECK ADD  CONSTRAINT [FK__Aluno__ID_Encarr__628FA481] FOREIGN KEY([ID_Encarregado_educacao])
REFERENCES [Aluno_Encarregado].[Encarregado_Educacao] ([ID_Encarregado])
GO
ALTER TABLE [Aluno_Encarregado].[Aluno] CHECK CONSTRAINT [FK__Aluno__ID_Encarr__628FA481]
GO
ALTER TABLE [Aluno_Encarregado].[Cartao]  WITH CHECK ADD  CONSTRAINT [FK__Cartao__ID_Codig__5AEE82B9] FOREIGN KEY([ID_Codigo])
REFERENCES [Aluno_Encarregado].[Aluno] ([ID_Codigo])
GO
ALTER TABLE [Aluno_Encarregado].[Cartao] CHECK CONSTRAINT [FK__Cartao__ID_Codig__5AEE82B9]
GO
ALTER TABLE [Aluno_Encarregado].[Movimentos]  WITH CHECK ADD  CONSTRAINT [FK__Movimento__ID_Co__66603565] FOREIGN KEY([ID_Codigo])
REFERENCES [Aluno_Encarregado].[Cartao] ([ID_Codigo])
GO
ALTER TABLE [Aluno_Encarregado].[Movimentos] CHECK CONSTRAINT [FK__Movimento__ID_Co__66603565]
GO
ALTER TABLE [Aluno_Encarregado].[Movimentos]  WITH CHECK ADD  CONSTRAINT [FK__Movimento__ID_Re__6B24EA82] FOREIGN KEY([ID_Refeicao])
REFERENCES [Geral].[Ementas_Dia] ([ID_Refeicao])
GO
ALTER TABLE [Aluno_Encarregado].[Movimentos] CHECK CONSTRAINT [FK__Movimento__ID_Re__6B24EA82]
GO
ALTER TABLE [Docentes].[Disciplina_Docente]  WITH CHECK ADD  CONSTRAINT [FK__Disciplin__ID_Di__5DCAEF64] FOREIGN KEY([ID_Disciplina])
REFERENCES [Docentes].[Disciplina] ([ID_Disciplina])
GO
ALTER TABLE [Docentes].[Disciplina_Docente] CHECK CONSTRAINT [FK__Disciplin__ID_Di__5DCAEF64]
GO
ALTER TABLE [Docentes].[Disciplina_Docente]  WITH CHECK ADD  CONSTRAINT [FK__Disciplin__ID_Do__5070F446] FOREIGN KEY([ID_Docente])
REFERENCES [Docentes].[Docente] ([ID_Docente])
GO
ALTER TABLE [Docentes].[Disciplina_Docente] CHECK CONSTRAINT [FK__Disciplin__ID_Do__5070F446]
GO
ALTER TABLE [Geral].[Aulas]  WITH CHECK ADD  CONSTRAINT [FK__Aulas__ID_Discip__5535A963] FOREIGN KEY([ID_Disciplina])
REFERENCES [Docentes].[Disciplina] ([ID_Disciplina])
GO
ALTER TABLE [Geral].[Aulas] CHECK CONSTRAINT [FK__Aulas__ID_Discip__5535A963]
GO
ALTER TABLE [Geral].[Avaliacoes]  WITH CHECK ADD  CONSTRAINT [FK__Avaliacoe__ID_Co__6383C8BA] FOREIGN KEY([ID_Codigo])
REFERENCES [Aluno_Encarregado].[Aluno] ([ID_Codigo])
GO
ALTER TABLE [Geral].[Avaliacoes] CHECK CONSTRAINT [FK__Avaliacoe__ID_Co__6383C8BA]
GO
ALTER TABLE [Geral].[Avaliacoes]  WITH CHECK ADD  CONSTRAINT [FK__Avaliacoe__ID_Di__6477ECF3] FOREIGN KEY([ID_Disciplina])
REFERENCES [Docentes].[Disciplina] ([ID_Disciplina])
GO
ALTER TABLE [Geral].[Avaliacoes] CHECK CONSTRAINT [FK__Avaliacoe__ID_Di__6477ECF3]
GO
ALTER TABLE [Geral].[Faltas]  WITH CHECK ADD  CONSTRAINT [FK__Faltas__ID_Aula__68487DD7] FOREIGN KEY([ID_Aula])
REFERENCES [Geral].[Aulas] ([ID_Aula])
GO
ALTER TABLE [Geral].[Faltas] CHECK CONSTRAINT [FK__Faltas__ID_Aula__68487DD7]
GO
ALTER TABLE [Geral].[Faltas]  WITH CHECK ADD  CONSTRAINT [FK__Faltas__ID_Codig__6754599E] FOREIGN KEY([ID_Codigo])
REFERENCES [Aluno_Encarregado].[Aluno] ([ID_Codigo])
GO
ALTER TABLE [Geral].[Faltas] CHECK CONSTRAINT [FK__Faltas__ID_Codig__6754599E]
GO
ALTER TABLE [Geral].[Turma_Aulas]  WITH CHECK ADD  CONSTRAINT [FK__Turma_Aul__ID_Au__619B8048] FOREIGN KEY([ID_Aula])
REFERENCES [Geral].[Aulas] ([ID_Aula])
GO
ALTER TABLE [Geral].[Turma_Aulas] CHECK CONSTRAINT [FK__Turma_Aul__ID_Au__619B8048]
GO
ALTER TABLE [Geral].[Turma_Aulas]  WITH CHECK ADD  CONSTRAINT [FK_Turma_Aulas_Turma] FOREIGN KEY([ID_Turma])
REFERENCES [Geral].[Turma] ([ID_Turma])
GO
ALTER TABLE [Geral].[Turma_Aulas] CHECK CONSTRAINT [FK_Turma_Aulas_Turma]
GO
/****** Object:  StoredProcedure [dbo].[procCacularNotaComPercentagem]    Script Date: 19/04/2021 23:52:57 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[procCacularNotaComPercentagem] 

		 
		 @pID_Codigo NVARCHAR(10), 
		 @pTIPO_AVALIACAO  NVARCHAR(50),
		 @pAno_Lectivo NVARCHAR(10), 
		 @pPeriodo NVARCHAR(10), 
		 @pID_Disciplina NVARCHAR(10), 
		 @NotaComPercentagem decimal (18,2) OUTPUT
											
AS 
BEGIN
     
		SET @NotaComPercentagem = 
							(SELECT Nota_teste
								FROM GestEscolar01.Geral.Avaliacoes 
								WHERE  ID_Codigo = @pID_Codigo 
									AND ID_Disciplina = @pID_Disciplina 
									AND Ano_letivo = @pAno_Lectivo 
									AND PERIODO = @pPeriodo 
									AND TIPO_AVALIACAO LIKE '%' + @pTIPO_AVALIACAO +'%' )

										*
							(SELECT PERCENTAGEM_NOTA 
								FROM GestEscolar01.Geral.Avaliacoes 
								WHERE ID_Codigo = @pID_Codigo 
									AND ID_Disciplina = @pID_Disciplina 
									AND Ano_letivo = @pAno_Lectivo 
									AND PERIODO = @pPeriodo 
									AND TIPO_AVALIACAO LIKE '%' + @pTIPO_AVALIACAO +'%')

END
GO
/****** Object:  StoredProcedure [dbo].[procContaNumInscritosTurma]    Script Date: 19/04/2021 23:52:57 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[procContaNumInscritosTurma]
	@pID_turma NVARCHAR(10), 
	@pTotal INT OUTPUT
AS
BEGIN
	-- Insert statements for procedure here
	--SELECT <@Param1, sysname, @p1>, <@Param2, sysname, @p2>
	SET @pTotal = (SELECT count(ID_Codigo) 
					FROM GestEscolar01.Aluno_Encarregado.Aluno  
					WHERE ID_Turma = @pID_turma)
END
GO
/****** Object:  StoredProcedure [dbo].[procedureVerificarCompraDuplicada]    Script Date: 19/04/2021 23:52:57 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[procedureVerificarCompraDuplicada]
	-- Add the parameters for the stored procedure here
	 @pData_dia smalldatetime, 
	 @pID_Refeicao NVARCHAR(10)
AS
BEGIN
    -- statements for procedure here
	SELECT Data_dia, ID_Refeicao
	FROM GestEscolar01.Geral.Ementas_Dia
	WHERE Data_dia = @pData_dia AND ID_Refeicao = @pID_Refeicao 
    
	
END
GO
/****** Object:  StoredProcedure [dbo].[procMostrarNotaAlunoPorDISCIPLINA]    Script Date: 19/04/2021 23:52:57 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[procMostrarNotaAlunoPorDISCIPLINA]
		 @pID_Codigo NVARCHAR(10), 
		 @pAno_Lectivo NVARCHAR(10), 
		 @pPeriodo NVARCHAR(10), 
		 @pID_Disciplina NVARCHAR(10)
	AS
BEGIN
		DECLARE @PNota_Final decimal (18,2)
		SELECT Nota_teste, Tipo_Avaliacao,
				(SELECT Nome_COMPLETO AS AAAA FROM ALUNO_ENCARREGADO.ALUNO WHERE  ID_Codigo =@pID_Codigo),
				(SELECT DESIGNACAO AS DESCIPLINA FROM DOCENTES.DISCIPLINA WHERE  ID_disciplina =@pID_Disciplina)
		FROM GestEscolar01.Geral.Avaliacoes WHERE  ID_Codigo = @pID_Codigo AND ID_Disciplina = @pID_Disciplina

		 EXEC procNotaPorDesciplina @pID_Codigo,@pAno_Lectivo,@pPeriodo,@pID_Disciplina, @PNota_Final OUTPUT
		 SELECT @PNota_Final AS NOTA_FINAL
END
GO
/****** Object:  StoredProcedure [dbo].[procNotaPorDesciplina]    Script Date: 19/04/2021 23:52:57 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[procNotaPorDesciplina]
	-- Add the parameters for the stored procedure here
		 @pID_Codigo NVARCHAR(10), 
		 @pAno_Lectivo NVARCHAR(10), 
		 @pPeriodo NVARCHAR(10), 
		 @pID_Disciplina NVARCHAR(10), 
	----------------------------------------------------
		 @PNota_Final decimal (18,2) OUTPUT

	AS
BEGIN

--variaveis locais
DECLARE @pNota_comPercentagem1 Decimal (18,2)
DECLARE @pNota_comPercentagem2 Decimal (18,2)
DECLARE @pNota_comPercentagem3 Decimal (18,2) 
 
EXEC procCacularNotaComPercentagem @pID_Codigo, 'Trabalho', @pAno_Lectivo, @pPeriodo, @pID_Disciplina, @pNota_comPercentagem1 OUTPUT 
EXEC procCacularNotaComPercentagem @pID_Codigo, 'Oral', @pAno_Lectivo, @pPeriodo, @pID_Disciplina, @pNota_comPercentagem3 OUTPUT 
EXEC procCacularNotaComPercentagem @pID_Codigo, 'Escrita', @pAno_Lectivo, @pPeriodo, @pID_Disciplina,@pNota_comPercentagem2 OUTPUT 


SET @PNota_Final =  @pNota_comPercentagem1 + @pNota_comPercentagem2 +  @pNota_comPercentagem3

END
GO
USE [master]
GO
ALTER DATABASE [GestEscolar01] SET  READ_WRITE 
GO
