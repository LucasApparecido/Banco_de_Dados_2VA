--DDL
create table convenio (
	id int not null,
	nome varchar(50),
	primary key(id)
);

create table paciente (
	cpf bigint not null,
	nome varchar(50),
	data_nascimento date,
	convenio_id int, 
	primary key(cpf),
	foreign key(convenio_id)
	references convenio(id)
);

create table especialidade (
	id int not null,
	nome varchar (150),
	primary key(id)
);

create table medico (
	crm int not null,
	convenio_id int,
	especialidade_id int,
	primary key(crm),
	foreign key(especialidade_id)
	references especialidade(id)
);

create table endereco (
	rua varchar(150),
	paciente_cpf bigint,
	foreign key(paciente_cpf)
	references paciente(cpf)
);

create table convenio_pac (
	paciente_cpf bigint,
	convenio_id int,
	foreign key(paciente_cpf)
	references paciente(cpf),
	foreign key(convenio_id)
	references convenio(id)
);

create table convenio_med (
	convenio_id int,
	especialidade_id int,
	medico_crm int,
	foreign key(convenio_id)
	references convenio(id),
	foreign key(especialidade_id)
	references especialidade(id),
	foreign key(medico_crm)
	references medico(crm)
);

drop table convenio;
drop table especialidade;
drop table paciente;
drop table medico;
drop table endereco;
drop table convenio_pac;
drop table convenio_med;