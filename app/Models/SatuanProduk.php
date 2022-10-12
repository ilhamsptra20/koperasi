<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class SatuanProduk extends Model
{
    use HasFactory;

    protected $table = 'mssatuanproduk';
    protected $fillable = [
        'id',
        'idProduk',
        'satuan',
        'qtyBalance',
        'haveChild',
        'qtyChild',
        'catatan',
        'fgActive',
        'createdBy',
        'createdDate',
    ];
}
