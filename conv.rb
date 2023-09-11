
files = Dir.glob('**/*.{c,h}')

funcs = [
  "pthread_create",
  "pthread_join",
  "pthread_mutex_init",
  "pthread_mutex_lock",
  "pthread_mutex_trylock",
  "pthread_mutex_unlock",
  "pthread_mutex_destroy",
  "pthread_cond_init",
  "pthread_cond_signal",
  "pthread_cond_destroy",
  "pthread_cond_wait",
  "pthread_cond_broadcast",
  "pthread_cond_timedwait",
  "pthread_cond_clockwait",
  "pthread_key_create",
  "pthread_setspecific",
  "pthread_getspecific",
  "pthread_key_delete",
  "pthread_rwlock_init",
  "pthread_rwlock_rdlock",
  "pthread_rwlock_wrlock",
  "pthread_rwlock_unlock",
  "pthread_rwlock_destroy",
  "pthread_once",
  
  # "pthread_rwlock_tryrdlock",
  # "pthread_rwlock_trywrlock",
  # "pthread_mutexattr_init",
  # "pthread_mutexattr_destroy",
  # "pthread_sigmask",
  # "pthread_setcancelstate",
  # "pthread_mutexattr_setpshared",
  # "pthread_attr_setschedpolicy",
  # "pthread_attr_setschedparam",
  # "pthread_setaffinity_np",
  # "pthread_spin_lock",
  # "pthread_spin_unlock",
  # "pthread_spin_destroy",
  # "pthread_spin_init",
  # "pthread_spin_trylock",
  # "pthread_exit",
  # "pthread_detach",
  # "pthread_mutexattr_settype",
  # "pthread_mutex_timedlock",
  # "pthread_mutex_consistent",
  # "pthread_mutexattr_setrobust",
  # "pthread_mutexattr_setprotocol",
]


files.each { |file_name|
  if !(file_name =~ /real_pthread.h/)
    text = File.read(file_name)
    modified = false
    funcs.each { |func|
      ret = text.gsub!(Regexp.new(func), "real_#{func}")
      if ret
        modified = true
      end
    }
    if modified
      if file_name =~ /^dpdk\//
        text = "#include \"real_pthread.h\"\n" + text
      else
        text = "#include \"spdk_internal/real_pthread.h\"\n" + text
      end
    end
    File.open(file_name, "w") {|file| file.puts text }
  end
}
