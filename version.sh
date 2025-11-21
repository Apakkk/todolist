#!/bin/bash

# Version Management Script with Git Integration
VERSION_FILE="version.json"
CHANGELOG="docs/CHANGELOG.md"

# Renklendirme
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m' # No Color

# Versiyon bilgisini oku
read_version() {
    if [ -f "$VERSION_FILE" ]; then
        VERSION=$(grep '"version"' $VERSION_FILE | sed 's/.*"version": "\(.*\)".*/\1/')
        echo "$VERSION"
    else
        echo "1.0.0"
    fi
}

# Versiyon güncelle
update_version() {
    local current_version=$1
    local version_type=$2
    
    IFS='.' read -ra VERSION_PARTS <<< "$current_version"
    local major="${VERSION_PARTS[0]}"
    local minor="${VERSION_PARTS[1]}"
    local patch="${VERSION_PARTS[2]}"
    
    case $version_type in
        major)
            major=$((major + 1))
            minor=0
            patch=0
            ;;
        minor)
            minor=$((minor + 1))
            patch=0
            ;;
        patch)
            patch=$((patch + 1))
            ;;
    esac
    
    echo "$major.$minor.$patch"
}

# CHANGELOG güncelle
update_changelog() {
    local version=$1
    local date=$(date +%Y-%m-%d)
    
    # Yeni release section'ını hazırla
    local new_section="## [$version] - $date\n\n### Changes\n\n- Version bump to $version\n\n"
    
    # CHANGELOG'un ilk satırını koru, sonra yeni section ekle
    if [ -f "$CHANGELOG" ]; then
        # Geçici dosya oluştur
        awk -v new="$new_section" '
            NR==7 {print new}
            {print}
        ' "$CHANGELOG" > "${CHANGELOG}.tmp"
        mv "${CHANGELOG}.tmp" "$CHANGELOG"
        
        echo -e "${GREEN}✅ CHANGELOG updated${NC}"
    fi
}

# Ana fonksiyon
main() {
    echo -e "${BLUE}=========================================="
    echo -e "📦 Automated Version Management"
    echo -e "==========================================${NC}"
    echo ""
    
    current_version=$(read_version)
    echo -e "Current Version: ${GREEN}$current_version${NC}"
    echo ""
    echo "Select version bump type:"
    echo "1) ${YELLOW}Patch${NC} (bug fixes)       - $current_version -> $(update_version $current_version patch)"
    echo "2) ${BLUE}Minor${NC} (new features)    - $current_version -> $(update_version $current_version minor)"
    echo "3) ${RED}Major${NC} (breaking changes)- $current_version -> $(update_version $current_version major)"
    echo "4) Keep current version"
    echo ""
    read -p "Enter your choice (1-4): " choice
    
    case $choice in
        1)
            new_version=$(update_version $current_version patch)
            version_type="patch"
            ;;
        2)
            new_version=$(update_version $current_version minor)
            version_type="minor"
            ;;
        3)
            new_version=$(update_version $current_version major)
            version_type="major"
            ;;
        4)
            new_version=$current_version
            echo -e "${YELLOW}⚠️  Keeping current version${NC}"
            exit 0
            ;;
        *)
            echo -e "${RED}❌ Invalid choice. Exiting.${NC}"
            exit 1
            ;;
    esac
    
    echo ""
    echo -e "${BLUE}=========================================="
    echo -e "📝 Version Update Summary"
    echo -e "==========================================${NC}"
    echo -e "Old Version:  ${YELLOW}$current_version${NC}"
    echo -e "New Version:  ${GREEN}$new_version${NC}"
    echo -e "Bump Type:    ${BLUE}$version_type${NC}"
    echo ""
    
    read -p "Continue with version bump? (y/n): " confirm
    if [ "$confirm" != "y" ]; then
        echo -e "${YELLOW}⚠️  Version bump cancelled${NC}"
        exit 0
    fi
    
    # version.json güncelle
    BUILD_DATE=$(date +%Y-%m-%d)
    cat > $VERSION_FILE << EOF
{
  "version": "$new_version",
  "buildDate": "$BUILD_DATE",
  "name": "TodoList Full Stack Application"
}
EOF
    
    echo ""
    echo -e "${GREEN}✅ version.json updated${NC}"
    
    # CHANGELOG güncelle
    update_changelog "$new_version"
    
    # Git işlemleri
    echo ""
    echo -e "${BLUE}=========================================="
    echo -e "� Git Operations"
    echo -e "==========================================${NC}"
    
    # Check if there are uncommitted changes
    if ! git diff --quiet || ! git diff --cached --quiet; then
        echo -e "${YELLOW}⚠️  Warning: You have uncommitted changes${NC}"
        read -p "Commit version changes? (y/n): " commit_confirm
        if [ "$commit_confirm" != "y" ]; then
            echo -e "${RED}❌ Please commit or stash your changes first${NC}"
            exit 1
        fi
    fi
    
    # Git add ve commit
    git add $VERSION_FILE $CHANGELOG
    git commit -m "chore(release): bump version to $new_version" || {
        echo -e "${RED}❌ Git commit failed${NC}"
        exit 1
    }
    echo -e "${GREEN}✅ Changes committed${NC}"
    
    # Git tag oluştur
    git tag -a "v$new_version" -m "Release version $new_version" || {
        echo -e "${RED}❌ Git tag failed${NC}"
        exit 1
    }
    echo -e "${GREEN}✅ Git tag 'v$new_version' created${NC}"
    
    # Push işlemleri
    echo ""
    read -p "Push to remote? (y/n): " push_confirm
    if [ "$push_confirm" = "y" ]; then
        current_branch=$(git branch --show-current)
        
        # Branch push
        git push origin $current_branch || {
            echo -e "${RED}❌ Branch push failed${NC}"
            exit 1
        }
        echo -e "${GREEN}✅ Branch '$current_branch' pushed${NC}"
        
        # Tag push
        git push origin "v$new_version" || {
            echo -e "${RED}❌ Tag push failed${NC}"
            exit 1
        }
        echo -e "${GREEN}✅ Tag 'v$new_version' pushed${NC}"
    else
        echo -e "${YELLOW}⚠️  Remember to push manually:${NC}"
        echo -e "   git push origin $(git branch --show-current)"
        echo -e "   git push origin v$new_version"
    fi
    
    echo ""
    echo -e "${BLUE}=========================================="
    echo -e "🎉 Version Management Complete!"
    echo -e "==========================================${NC}"
    echo -e "Version:      ${GREEN}v$new_version${NC}"
    echo -e "Build Date:   ${BLUE}$BUILD_DATE${NC}"
    echo -e "Commit:       ${GREEN}✓${NC}"
    echo -e "Tag:          ${GREEN}✓${NC}"
    if [ "$push_confirm" = "y" ]; then
        echo -e "Pushed:       ${GREEN}✓${NC}"
    else
        echo -e "Pushed:       ${YELLOW}✗ (manual)${NC}"
    fi
    echo ""
    echo -e "${YELLOW}Next steps:${NC}"
    echo -e "1. Update CHANGELOG.md with detailed release notes"
    echo -e "2. Create GitHub release from tag v$new_version"
    echo -e "3. Deploy to production if needed"
    echo ""
}

main
