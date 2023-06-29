-- utils.lua

-- Fonction pour créer un fichier
local function create_file(filename)
    vim.cmd('edit ' .. filename)
  end
  
  -- Fonction pour créer un dossier
  local function create_directory(dirname)
    vim.fn.mkdir(dirname, 'p')
  end
  
  -- Fonction pour supprimer un fichier
  local function delete_file(filename)
    vim.fn.delete(filename)
  end
  
  -- Fonction pour supprimer un dossier et ses fichiers récursivement
  local function delete_directory(dirname)
    vim.fn.delete(dirname, 'rf')
  end
  
  -- Fonction pour trier les fichiers et dossiers par date de création
  local function sort_files_by_creation_date(files)
    local sorted_files = {}
  
    -- Récupérer la date de création pour chaque fichier/dossier
    for _, file in ipairs(files) do
      local creation_date = vim.fn.getftime(file)
      table.insert(sorted_files, { name = file, creation_date = creation_date })
    end
  
    -- Trier les fichiers/dossiers par date de création (du plus ancien au plus récent)
    table.sort(sorted_files, function(a, b)
      return a.creation_date < b.creation_date
    end)
  
    -- Retourner la liste triée des fichiers/dossiers
    return sorted_files
  end
  
  -- Exportez les fonctions utilitaires
  return {
    create_file = create_file,
    create_directory = create_directory,
    delete_file = delete_file,
    delete_directory = delete_directory,
    sort_files_by_creation_date = sort_files_by_creation_date,
  }
  