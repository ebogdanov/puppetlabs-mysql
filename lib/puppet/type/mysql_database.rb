Puppet::Type.newtype(:mysql_database) do
  @doc = <<-PUPPET
    @summary
      Manage a MySQL database.

    @api private
  PUPPET

  ensurable

  autorequire(:file) { '/root/.my.cnf' }
  autorequire(:class) { 'mysql::server' }

  newparam(:name, namevar: true) do
    desc 'The name of the MySQL database to manage.'
  end

  newproperty(:charset) do
    desc 'The CHARACTER SET setting for the database'
    defaultto :utf8
    newvalue(%r{^\S+$})
  end

  newproperty(:collate) do
    desc 'The COLLATE setting for the database'
    defaultto :utf8_general_ci
    newvalue(%r{^\S+$})
  end

  newproperty(:bin_log) do
    desc 'Disables SQL_LOG_BIN usage. Can be helpful for saving replication state'
    defaultto "yes"
    newvalues("yes", "no")
    # This property is used only during resource creation
    # so changing its value should not trigger resource update (correction)
    def insync?(is)
      true
    end
  end
end
