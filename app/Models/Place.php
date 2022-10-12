<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class Place extends Model
{
    use HasFactory;

    protected $table = 'msplace';

    protected $fillable = [
        'placeType',
        'nama',
        'alamat',
        'filePhoto',
        'fgActive',
        'catatan',
        'createdBy',
        'createdDate',
        'modifiedBy',
        'modifiedDate',
    ];
}
