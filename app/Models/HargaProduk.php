<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class HargaProduk extends Model
{
    use HasFactory;

    protected $table = 'mshargaproduk';
    
    protected $fillable = [
        'id',
        'idPlace',
        'idProduk',
        'mulaiEfektif',
        'selesaiEfektif',
        'hargaBeli',
        'markUp',
        'hargaJual',
        'catatan',
        'createdBy',
        'createdDate',
    ];
}
