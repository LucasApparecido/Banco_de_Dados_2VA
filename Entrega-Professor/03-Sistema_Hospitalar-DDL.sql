--DDL
create table convenio (
	id int not null,
	nome varchar(100) not null,
	primary key(id)
);

create table paciente (
	cpf bigint not null,
	nome varchar(50) not null,
	data_nascimento date not null,
	sexo char(1) not null,
	convenio_id int not null,
	primary key(cpf),
	foreign key(convenio_id) references convenio(id)
);

create table endereco (
	rua varchar(150) not null,
	paciente_cpf bigint not null,
	cidade varchar(50) not null,
	numero int not null,
	cep int not null,
	primary key(paciente_cpf),
	foreign key(paciente_cpf) references paciente(cpf)
);

create table especialidade (
	id int not null,
	nome varchar (150) not null,
	primary key(id)
);

create table medico (
	crm int not null,
	nome varchar(50) not null,
	primary key(crm)
);

create table medico_esp (
	medico_crm int not null,
	especialidade_id int not null,
	primary key(medico_crm, especialidade_id),
	foreign key(medico_crm) references medico(crm),
	foreign key(especialidade_id) references especialidade(id)
);

create table convenio_pac (
	paciente_cpf bigint,
	convenio_id int,
	primary key(paciente_cpf, convenio_id),
	foreign key(paciente_cpf) references paciente(cpf),
	foreign key(convenio_id) references convenio(id)
);

create table convenio_med (
	convenio_id int not null,
	especialidade_id int not null,
	medico_crm int not null,
	primary key(convenio_id, especialidade_id, medico_crm),
	foreign key(convenio_id) references convenio(id),
	foreign key(especialidade_id, medico_crm) references medico_esp(especialidade_id, medico_crm)
);

create table consulta (
	data_consulta timestamp not null,
	especialidade_id int not null,
	convenio_id int not null,
	paciente_cpf bigint not null,
	medico_crm int not null,
	valor float not null,
	primary key(
		data_consulta,
		especialidade_id,
		convenio_id,
		paciente_cpf,
		medico_crm
	),
	foreign key(especialidade_id, convenio_id, medico_crm) references convenio_med(especialidade_id, convenio_id, medico_crm),
	foreign key(paciente_cpf, convenio_id) references convenio_pac(paciente_cpf, convenio_id)
);

create table exame (
	id int not null,
	nome varchar(50) not null,
	valor float not null,
	primary key(id)
);

create table medicamento (
	id int not null,
	nome varchar(50) not null,
	primary key(id)
);

create table quarto (numero int not null, primary key(numero));

create table internacao (
	id int not null,
	data_internacao timestamp not null,
	data_alta timestamp null,
	data_consulta timestamp not null,
	especialidade_id int not null,
	convenio_id int not null,
	paciente_cpf bigint not null,
	medico_crm int not null,
	quarto_numero int not null,
	primary key(id),
	foreign key(
		data_consulta,
		especialidade_id,
		convenio_id,
		paciente_cpf,
		medico_crm
	) references consulta(
		data_consulta,
		especialidade_id,
		convenio_id,
		paciente_cpf,
		medico_crm
	),
	foreign key(quarto_numero) references quarto(numero)
);

create index idx_internacao on internacao(
	data_consulta,
	especialidade_id,
	convenio_id,
	paciente_cpf,
	medico_crm
);

create table consulta_exa (
	data_consulta timestamp not null,
	paciente_cpf bigint not null,
	convenio_id int not null,
	especialidade_id int not null,
	medico_crm int not null,
	exame_id int not null,
	id int not null,
	data_agenda timestamp not null,
	data_realizacao timestamp null,
	resultado varchar(100) null,
	valor float not null,
	primary key(id),
	foreign key(
		data_consulta,
		paciente_cpf,
		convenio_id,
		especialidade_id,
		medico_crm
	) references consulta(
		data_consulta,
		paciente_cpf,
		convenio_id,
		especialidade_id,
		medico_crm
	),
	foreign key(exame_id) references exame(id)
);

create table consulta_medic (
	data_consulta timestamp not null,
	paciente_cpf bigint not null,
	convenio_id int not null,
	especialidade_id int not null,
	medico_crm int not null,
	medicamento_id int not null,
	data_prescricao timestamp not null,
	primary key(
		data_consulta,
		paciente_cpf,
		convenio_id,
		especialidade_id,
		medico_crm,
		medicamento_id
	),
	foreign key(
		data_consulta,
		paciente_cpf,
		convenio_id,
		especialidade_id,
		medico_crm
	) references consulta(
		data_consulta,
		paciente_cpf,
		convenio_id,
		especialidade_id,
		medico_crm
	),
	foreign key(medicamento_id) references medicamento(id)
);

create table internacao_exa (
	internacao_id int not null,
	exame_id int not null,
	id int not null,
	data_agenda timestamp not null,
	data_realizacao timestamp null,
	resultado varchar(100) null,
	valor float not null,
	primary key(id),
	foreign key(internacao_id) references internacao(id),
	foreign key(exame_id) references exame(id)
);

create table internacao_medic (
	internacao_id int not null,
	medicamento_id int not null,
	id int not null,
	data_aplicacao timestamp not null,
	primary key(id),
	foreign key(internacao_id) references internacao(id),
	foreign key(medicamento_id) references medicamento(id)
);