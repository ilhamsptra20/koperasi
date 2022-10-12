<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class Satuan extends Model
{
    use HasFactory;

    protected $table = 'mssatuan';

    protected $fillable = [
        'satuan',
        'satuanDesc',
        'fgActive',
        'createdBy',
        'createdDate',
    ];
}
