<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class Vendor extends Model
{
    use HasFactory;

    protected $table = 'msvendor';
    protected $fillable = [
        'nama',
        'alamat',
        'noHp',
        'email',
        'vendorDesc',
        'filePhoto',
        'catatan',
        'fgActive',
        'createdBy',
        'createdDate',
        'modifiedBy',
        'modifiedDate',
    ];

}
