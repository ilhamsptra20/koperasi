<?php

namespace Database\Seeders;

use App\Models\User;
use Illuminate\Database\Seeder;

class DatabaseSeeder extends Seeder
{
    /**
     * Seed the application's database.
     *
     * @return void
     */
    public function run()
    {
        // \App\Models\User::factory(10)->create();

        User::create([
            'username' => 'coba',
            'password' => bcrypt('12345678'),
            'nama' => 'ilham',
            'alamat' => 'deket',
            'usia' => 18,
            'jenisKelamin' => 'L',
            'noHp' => '08988789340',
            'email' => 'anjay@email.com',
            'place' =>'1',
            'keanggotaan' => '1',
            'fgActive' => 'Y',
            'modifiedBy' => -1,
            'userLevelId' => 1,
        ]);
    }
}
