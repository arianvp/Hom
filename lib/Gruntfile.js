'use strict';

module.exports = function(grunt) {

  // Project configuration.
  grunt.initConfig({
   // nodeunit: {
   //   files: ['test/**/*_test.js'],
   // },
    jshint: {
      options: {
        jshintrc: '.jshintrc'
      },
      gruntfile: {
        src: 'Gruntfile.js'
      },
      lib: {
        src: ['lib/**/*.js']
      },
//      test: {
//j        src: ['test/**/*.js']
//      },
    },
    browserify: {
      all: {
        src: 'lib/**/*.js',
        dest: 'bundle.js'
      }
    },
    watch: {
      gruntfile: {
        files: '<%= jshint.gruntfile.src %>',
        tasks: ['jshint:gruntfile']
      },
      lib: {
        files: '<%= jshint.lib.src %>',
        tasks: ['jshint:lib', 'nodeunit']
      },
      test: {
        files: '<%= jshint.test.src %>',
        tasks: ['jshint:test', 'nodeunit']
      },
    },
  });

  // These plugins provide necessary tasks.
  grunt.loadNpmTasks('grunt-contrib-nodeunit');
  grunt.loadNpmTasks('grunt-contrib-jshint');
  grunt.loadNpmTasks('grunt-contrib-watch');
  grunt.loadNpmTasks('grunt-browserify');
  grunt.loadNpmTasks('grunt-file-append');
  // Default task.
  grunt.registerTask('default', ['jshint', 'browserify', ]);

};
