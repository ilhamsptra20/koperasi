<?php

namespace App\Models;

use Illuminate\Contracts\Auth\MustVerifyEmail;
use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Foundation\Auth\User as Authenticatable;
use Illuminate\Notifications\Notifiable;
use Laravel\Sanctum\HasApiTokens;

class User extends Authenticatable
{
    protected $table = 'msuser';
    use HasApiTokens, HasFactory, Notifiable;

    /**
     * The attributes that are mass assignable.
     *
     * @var array<int, string>
     */
    protected $fillable = [
        'Username',
        'password',
        'Nama',
        'Alamat',
        'Usia',
        'JenisKelamin',
        'NoHp',
        'email',
        'Place',
        'FilePhoto',
        'Catatan',
        'Keanggotaan',
        'FgActive',
        'CreatedBy',
        'CreatedDate',
        'ModifiedBy',
        'ModifiedDate',
        'userlevel'
    ];

    /**
     * The attributes that should be hidden for serialization.
     *
     * @var array<int, string>
     */
    protected $hidden = [
        'password',
    ];
}