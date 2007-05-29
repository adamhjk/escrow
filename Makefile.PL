use inc::Module::Install;

name 'Escrow';
all_from 'lib/Escrow.pm';

requires 'Catalyst' => '5.7001';
requires 'Catalyst::Plugin::ConfigLoader';
requires 'Catalyst::Plugin::Static::Simple';
requires 'Catalyst::Action::RenderView';
requires 'Catalyst::Log::Log4perl';
requires 'Catalyst::View::REST::Data::Serializer';
requires 'Config::General'; 
requires 'Params::Validate';
requires 'Exception::Class';
requires 'Exception::Class::TryCatch';
requires 'Moose';
requires 'LWP::UserAgent';
requires 'Log::Log4perl';
requires 'Module::Pluggable';
requires 'YAML::Syck';
requires 'Data::Serializer';
requires 'DBIx::Class';
requires 'DBIx::Class::Schema';
requires 'Catalyst::Model::DBIC';
requires 'DBD::SQLite';
requires 'SQL::Translator';

catalyst;

install_script glob('bin/*');

auto_install;
WriteAll;
